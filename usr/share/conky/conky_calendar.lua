-- Month calendar for conky_clock: ${lua_parse calendar}
-- Monday first, ISO week numbers, today in light steel, weekend dimmed.
-- Each line starts with ${alignr} so it hugs the right edge (needs a mono font).

function conky_calendar()
	local now = os.date('*t')
	local last = os.date('*t', os.time{ year = now.year, month = now.month + 1, day = 0, hour = 12 }).day
	local first_wday = os.date('*t', os.time{ year = now.year, month = now.month, day = 1, hour = 12 }).wday
	local offset = (first_wday + 5) % 7 -- days before the 1st in the first row (Monday = 0)

	local lines = { '${alignr}${color1}wk  Mo Tu We Th Fr Sa Su' }
	local day = 1 - offset
	while day <= last do
		-- os.time normalises day <= 0 into the previous month, which gives the row's Monday
		local monday = os.time{ year = now.year, month = now.month, day = day, hour = 12 }
		local cells = {}
		for col = 0, 6 do
			local d = day + col
			if d < 1 or d > last then
				cells[#cells + 1] = '  '
			elseif d == now.day then
				cells[#cells + 1] = string.format('${color2}%2d', d)
			elseif col >= 5 then
				cells[#cells + 1] = string.format('${color1}%2d', d)
			else
				cells[#cells + 1] = string.format('${color}%2d', d)
			end
		end
		lines[#lines + 1] = '${alignr}${color1}' .. os.date('%V', monday) .. '  ' .. table.concat(cells, ' ')
		day = day + 7
	end
	return table.concat(lines, '\n')
end
