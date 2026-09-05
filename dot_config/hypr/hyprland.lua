local terminal = "foot"
local menu = "fuzzel"
local main_mod = "SUPER"

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

hl.config({
	input = {
		kb_layout = "pl",
		follow_mouse = 1,
		touchpad = {
			natural_scroll = true,
			tap_to_click = true,
		},
	},

	general = {
		gaps_in = 5,
		gaps_out = 10,
		border_size = 2,
		layout = "dwindle",
	},

	decoration = {
		rounding = 10,
		active_opacity = 1.0,
		inactive_opacity = 0.96,
		blur = {
			enabled = true,
			size = 5,
			passes = 2,
			vibrancy = 0.12,
		},
	},

	dwindle = {
		preserve_split = true,
	},

	misc = {
		disable_hyprland_logo = true,
		force_default_wallpaper = 0,
	},
})

hl.curve("swift", { type = "bezier", points = { { 0.25, 0.9 }, { 0.1, 1.0 } } })
hl.curve("smooth", { type = "bezier", points = { { 0.2, 0.0 }, { 0.0, 1.0 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 4, bezier = "swift", style = "popin 85%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "smooth", style = "popin 85%" })
hl.animation({ leaf = "border", enabled = true, speed = 5, bezier = "swift" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "smooth" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "swift", style = "slide" })

hl.bind(main_mod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(main_mod .. " + B", hl.dsp.exec_cmd("firefox"))
hl.bind(main_mod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(main_mod .. " + E", hl.dsp.exec_cmd("thunar"))
hl.bind(main_mod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(main_mod .. " + W", hl.dsp.window.close())
hl.bind(main_mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(main_mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + P", hl.dsp.window.pseudo())
hl.bind(main_mod .. " + J", hl.dsp.layout("togglesplit"))

hl.bind(main_mod .. " + escape", hl.dsp.exec_cmd("bash " .. os.getenv("HOME") .. "/.config/hypr/scripts/powermenu.sh"))

hl.bind(main_mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(main_mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(main_mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(main_mod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(main_mod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(main_mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(main_mod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(main_mod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))
hl.bind(main_mod .. " + CTRL + left", hl.dsp.window.resize({ x = -40, y = 0, relative = true }))
hl.bind(main_mod .. " + CTRL + right", hl.dsp.window.resize({ x = 40, y = 0, relative = true }))
hl.bind(main_mod .. " + CTRL + up", hl.dsp.window.resize({ x = 0, y = -40, relative = true }))
hl.bind(main_mod .. " + CTRL + down", hl.dsp.window.resize({ x = 0, y = 40, relative = true }))
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

for workspace = 1, 10 do
	local key = workspace % 10
	hl.bind(main_mod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
	hl.bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }))
end

hl.bind("Print", hl.dsp.exec_cmd("sh -c 'grim - | wl-copy'"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("sh -c 'grim -g \"$(slurp)\" - | wl-copy'"))
hl.bind(
	main_mod .. " + S",
	hl.dsp.exec_cmd(
		'sh -c \'mkdir -p "$HOME/Pictures/Screenshots" && grim "$HOME/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"\''
	)
)
hl.bind(
	main_mod .. " + SHIFT + S",
	hl.dsp.exec_cmd(
		'sh -c \'selection="$(slurp)" && mkdir -p "$HOME/Pictures/Screenshots" && grim -g "$selection" "$HOME/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"\''
	)
)

hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.on("hyprland.start", function()
	hl.exec_cmd("uwsm app -- waybar")
	hl.exec_cmd("uwsm app -- mako")
	hl.exec_cmd("uwsm app -- hyprpaper")
	hl.exec_cmd("uwsm app -- hypridle")
end)
