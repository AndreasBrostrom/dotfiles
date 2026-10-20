-- Machine detection shared by the niri conky configs, so the same files work on the
-- laptop and the office desktop. Load from a config with dofile(); runs once at start.
-- Fields:
--   iface, wireless    network interface with the default route, and whether it is Wi-Fi
--   cpu_temp, gpu_temp conky snippets for the temperatures ('' when there is no sensor)
--   host, bios, cpu, gpu, cores, threads, display, desktop   static info for conky_info
--   has(cmd)           whether a command is installed

local M = {}

local function sh(cmd)
	local p = io.popen(cmd .. ' 2>/dev/null')
	local out = p:read('*a') or ''
	p:close()
	return (out:gsub('%s+$', ''))
end

local function read(path)
	local f = io.open(path)
	if not f then return '' end
	local s = f:read('*l') or ''
	f:close()
	return (s:gsub('%s+$', ''))
end

function M.has(cmd)
	return sh('command -v ' .. cmd) ~= ''
end

-- Network: default-route interface, else the first non-loopback one that is up
M.iface = sh("ip route show default | awk '{print $5; exit}'")
if M.iface == '' then
	M.iface = sh("ip -br link | awk '$1 != \"lo\" && $2 == \"UP\" {print $1; exit}'")
end
if M.iface == '' then M.iface = 'lo' end
M.wireless = sh('test -d /sys/class/net/' .. M.iface .. '/wireless && echo y') == 'y'

-- Temperatures: first matching hwmon sensor by name
local hwmon = {}
for name in sh('cat /sys/class/hwmon/hwmon*/name'):gmatch('[^\n]+') do hwmon[name] = true end

M.cpu_temp = ''
for _, name in ipairs({ 'k10temp', 'zenpower', 'coretemp', 'cpu_thermal', 'acpitz' }) do
	if hwmon[name] then
		M.cpu_temp = '${hwmon ' .. name .. ' temp 1}°C'
		break
	end
end

M.gpu_temp = ''
if hwmon.amdgpu then
	M.gpu_temp = '${hwmon amdgpu temp 1}°C'
elseif M.has('nvidia-smi') then
	M.gpu_temp = '${execi 10 nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader}°C'
end

-- Host: laptops fill product_version, desktops often only have the board name
local function generic(s)
	return s == '' or s:match('[Tt]o be filled') or s:match('^System ') or s:match('^Default string')
		or s:match('^None') or s:match('^Not Applicable')
end
M.host = read('/sys/class/dmi/id/product_version')
if generic(M.host) then M.host = read('/sys/class/dmi/id/product_name') end
if generic(M.host) then
	M.host = read('/sys/class/dmi/id/board_vendor') .. ' ' .. read('/sys/class/dmi/id/board_name')
end
M.bios = read('/sys/class/dmi/id/bios_version'):match('^%S*')

M.cpu = sh("grep -m1 'model name' /proc/cpuinfo | sed 's/.*: //; s/ with .*//; s/(R)//g; s/(TM)//g; s/ @ .*//; s/ CPU / /; s/ [0-9]*-Core Processor//'")
M.gpu = sh("lspci | grep -m1 -E 'VGA|3D|Display' | sed 's/.*: //; s/.*\\[\\(.*\\)\\].*/\\1/'")
M.threads = sh('nproc')
M.cores = sh("lscpu | awk -F: '/^Core\\(s\\) per socket/ {gsub(/ /, \"\", $2); print $2}'")

-- Display: mode of the output this widget runs on (start_conky_niri/start_conky_xfce set CONKY_OUTPUT)
local output = os.getenv('CONKY_OUTPUT') or ''
local wayland = os.getenv('WAYLAND_DISPLAY') ~= nil
M.display = ''
if output ~= '' and wayland then
	M.display = sh("niri msg --json outputs | jq -r --arg o '" .. output .. "' "
		.. "'.[$o] | .modes[.current_mode] as $m | \"\\($m.width)x\\($m.height) @ \\($m.refresh_rate / 1000 | floor) Hz\"'")
elseif output ~= '' then
	M.display = sh("xrandr | awk -v o='" .. output .. "' '$1 == o {f = 1; next} "
		.. "f && /\\*/ {print $1 \" @ \" int($2) \" Hz\"; exit} f && !/^ / {exit}'")
end

-- Desktop: compositor or desktop environment and its version, for the info header
local desktop = os.getenv('XDG_CURRENT_DESKTOP') or ''
if desktop:match('niri') then
	M.desktop = 'niri ' .. sh("niri --version | cut -d' ' -f2")
elseif desktop:match('XFCE') then
	M.desktop = 'Xfce ' .. sh("xfce4-session --version | head -1 | sed 's/.*(Xfce \\(.*\\))/\\1/'")
else
	M.desktop = desktop
end

return M
