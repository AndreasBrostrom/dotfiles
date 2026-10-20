-- Backdrops for the niri conky widgets, drawn with cairo before the text.
-- Use with own_window_color = '#00000000' and
--   lua_draw_hook_pre = 'panel x,y,w,h x,y,w,h ...'
-- Each x,y,w,h is a graph's spot in window pixels (text starts at 18,18 with
-- border_inner_margin = 16); it gets a dark box with a faint grey outline.
-- The whole-widget panel (#151515 at ~30%, 8px corners) can be switched off with PANEL.

require 'cairo'
local wayland = os.getenv('WAYLAND_DISPLAY') ~= nil
if not wayland then require 'cairo_xlib' end

local PANEL = false -- testing without the widget backdrop; true brings it back
local PANEL_RADIUS = 8
local PANEL_RGBA = { 0x15 / 255, 0x15 / 255, 0x15 / 255, 0.30 }

local BOX_PAD = 4    -- breathing room around the graph
local BOX_RADIUS = 4
local BOX_FILL = { 0.05, 0.05, 0.05, 0.45 }
local BOX_LINE = { 0.75, 0.75, 0.75, 0.12 }

local function rounded_rect(cr, x, y, w, h, r)
	cairo_new_sub_path(cr)
	cairo_arc(cr, x + w - r, y + r, r, -math.pi / 2, 0)
	cairo_arc(cr, x + w - r, y + h - r, r, 0, math.pi / 2)
	cairo_arc(cr, x + r, y + h - r, r, math.pi / 2, math.pi)
	cairo_arc(cr, x + r, y + r, r, math.pi, 3 * math.pi / 2)
	cairo_close_path(cr)
end

function conky_panel(...)
	if conky_window == nil then return end
	-- Wayland: conky_surface() hands out the window's surface; X11: build an xlib one
	-- (conky_surface exists on X11 too, but drawing to it there shows nothing)
	local owned = not wayland
	local surface = owned
		and cairo_xlib_surface_create(conky_window.display, conky_window.drawable,
			conky_window.visual, conky_window.width, conky_window.height)
		or conky_surface()
	local cr = cairo_create(surface)

	if PANEL then
		rounded_rect(cr, 0, 0, conky_window.width, conky_window.height, PANEL_RADIUS)
		cairo_set_source_rgba(cr, table.unpack(PANEL_RGBA))
		cairo_fill(cr)
	end

	for _, spec in ipairs({ ... }) do
		local x, y, w, h = spec:match('^(%d+),(%d+),(%d+),(%d+)$')
		if x then
			rounded_rect(cr, x - BOX_PAD + 0.5, y - BOX_PAD + 0.5, w + 2 * BOX_PAD, h + 2 * BOX_PAD, BOX_RADIUS)
			cairo_set_source_rgba(cr, table.unpack(BOX_FILL))
			cairo_fill_preserve(cr)
			cairo_set_source_rgba(cr, table.unpack(BOX_LINE))
			cairo_set_line_width(cr, 1)
			cairo_stroke(cr)
		end
	end

	cairo_destroy(cr)
	if owned then cairo_surface_destroy(surface) end
end
