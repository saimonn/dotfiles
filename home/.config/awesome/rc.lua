-- default rc.lua for shifty
--
-- Standard awesome library
require("awful")
require("awful.autofocus")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- shifty - dynamic tagging library
require("shifty")
require("vicious")
require("wicked")

-- useful for debugging, marks the beginning of rc.lua exec
print("Entered rc.lua: " .. os.time())

-- Variable definitions
-- Themes define colours, icons, and wallpapers
-- The default is a dark theme
theme_path = "/usr/share/awesome/themes/default/theme.lua"
-- Uncommment this for a lighter theme
-- theme_path = "/usr/share/awesome/themes/sky/theme"

-- Actually load theme
beautiful.init(theme_path)

-- This is used later as the default terminal and editor to run.
terminal = "x-terminal-emulator"
browser = "firefox"
musicplayer = "ario"
mail = "thunderbird"
chat = terminal .. " -e irssi"
-- amixer -c 'PCH' : carte 'PCH'
volume_up_cmd   = "/usr/bin/amixer -c 'PCH' sset 'Master',0 2dB+"
volume_down_cmd = "/usr/bin/amixer -c 'PCH' sset 'Master',0 2dB-"

xlock_cmd = "/usr/bin/i3lock"

editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

awful.util.spawn_with_shell(mail)
awful.util.spawn_with_shell(chat)
awful.util.spawn_with_shell("~/bin/notify-listener.py")
awful.util.spawn_with_shell("nm-applet")
awful.util.spawn_with_shell("numlockx")
awful.util.spawn_with_shell("fdpowermon0") -- battery 0 systray
awful.util.spawn_with_shell("fdpowermon1") -- battery 1 systray
awful.util.spawn_with_shell("ssh-add")
awful.util.spawn_with_shell("/usr/bin/volumeicon")
awful.util.spawn_with_shell("workrave")

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key, I suggest you to remap
-- Mod4 to another key using xmodmap or other tools.  However, you can use
-- another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating
}

-- Define if we want to use titlebar on all applications.
use_titlebar = false

-- TIP: will assign a tag to the second screen but only when it is attached:
max_screen = math.max(screen.count(), 2) 

-- Shifty configured tags.
shifty.config.tags = {

    ["1:chat"] = {
        layout      = awful.layout.suit.tile,
        mwfact      = 0.6,
        exclusive   = false,
        screen      = 1,
        position    = 1,
        slave       = true
    },
    ["2:mail"] = {
        layout      = awful.layout.suit.tile,
        mwfact      = 0.5,
        exclusive   = false,
        screen      = 1,
        position    = 2,
        spawn       = mail,
        slave       = true
    },
    ["3:term"] = {
        layout      = awful.layout.suit.tile,
        exclusive   = false,
        position    = 3,
        init        = true,
        screen      = 1,
        slave       = true,
    },
    ["4:media"] = {
        layout      = awful.layout.suit.max,
        exclusive   = true,
        screen      = 1,
        position    = 4,
	      spawn       = musicplayer,
    },

    ["5:web"] = {
        layout      = awful.layout.suit.tile.bottom,
        mwfact      = 0.5,
        exclusive   = true,
        max_clients = 1,
        position    = 5,
        spawn       = browser,
	      init        = true,
        screen      = max_screen
    },
    ["6:Terminaux"] = {
        layout      = awful.layout.suit.tile,
        exclusive   = false,
        screen      = max_screen,
        position    = 6,
        init        = true,
        spawn       = terminal
    },
    ["7:ToutesDirections"] = {
        layout      = awful.layout.suit.tile,
        exclusive   = false,
        position    = 7,
        spawn       = terminal,
        screen      = max_screen
    },
    ["8:AutresDirections"] = {
        layout      = awful.layout.suit.tile,
        exclusive   = false,
        position    = 8,
        spawn       = terminal,
        screen      = max_screen
    },
    ["9:office"] = {
        layout      = awful.layout.suit.tile,
        position    = 9,
        screen      = max_screen
    },

    ["fs"] = {
            rel_index = 1, -- always open next to the current tag and not at the
                    -- end. (0 would create it before current tag)
    },
}

-- SHIFTY: application matching rules
-- order here matters, early rules will be applied first
shifty.config.apps = {
    {
        match = {
            "irssi",
            "xchat",
        },
        tag = "1:chat",
    },
    {
        match = {
            "Navigator",
            "Vimperator",
            "Gran Paradiso",
        },
        tag = "5:web",
    },
    {
        match = {
            "Shredder.*",
            "Thunderbird",
            "mutt",
        },
        tag = "2:mail",
    },
    {
        match = {
            "pcmanfm",
        },
        slave = true
    },
    {
        match = {
            "Mplayer.*",
            "ario",
            "Mirage",
            "gimp",
            "gtkpod",
            "Ufraw",
            "easytag",
        },
        tag = "4:media",
        -- nopopup = true,
    },
    {
        match = {
            "LibreOffice.*",
            "OpenOffice.*",
            "soffice.*",
            "Abiword",
            "Gnumeric",
        },
        tag = "9:office",
    },
    {
        match = {
            "MPlayer",
            "Gnuplot",
            "galculator",
        },
        float = true,
    },
    {
        match = {
            terminal,
        },
        honorsizehints = false,
        slave = true,
    },
    {
        match = {""},
        buttons = awful.util.table.join(
            awful.button({}, 1, function (c) client.focus = c; c:raise() end),
            awful.button({modkey}, 1, function(c)
                client.focus = c
                c:raise()
                awful.mouse.client.move(c)
                end),
            awful.button({modkey}, 3, awful.mouse.client.resize)
            )
    },
}

-- SHIFTY: default tag creation rules
-- parameter description
--  * floatBars : if floating clients should always have a titlebar
--  * guess_name : should shifty try and guess tag names when creating
--                 new (unconfigured) tags?
--  * guess_position: as above, but for position parameter
--  * run : function to exec when shifty creates a new tag
--  * all other parameters (e.g. layout, mwfact) follow awesome's tag API
shifty.config.defaults = {
    layout = awful.layout.suit.tile,
    ncol = 1,
    -- mwfact = 0.50,
    floatBars = true,
    guess_name = true,
    guess_position = true,
}

--  Wibox
-- Create a textbox widget
mytextclock = awful.widget.textclock({align = "right"})

-- Create a laucher widget and a main menu
myawesomemenu = {
    {"manual", terminal .. " -e man awesome"},
    {"edit config",
     editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua"},
    {"restart", awesome.restart},
    {"quit", awesome.quit}
}

mymainmenu = awful.menu(
    {
        items = {
            {"awesome", myawesomemenu, beautiful.awesome_icon},
              {"open terminal", terminal}}
          })

mylauncher = awful.widget.launcher({image = image(beautiful.awesome_icon),
                                     menu = mymainmenu})

-- Create a systray
mysystray = widget({type = "systray", align = "right"})

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
    awful.button({}, 1, awful.tag.viewonly),
    awful.button({modkey}, 1, awful.client.movetotag),
    awful.button({}, 3, function(tag) tag.selected = not tag.selected end),
    awful.button({modkey}, 3, awful.client.toggletag),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
    )





mytasklist = {}
mytasklist.buttons = awful.util.table.join(
    awful.button({}, 1, function(c)
        if not c:isvisible() then
            awful.tag.viewonly(c:tags()[1])
        end
        client.focus = c
        c:raise()
        end),
    awful.button({}, 3, function()
        if instance then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({width=250})
        end
        end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
        end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
        end))

------------------------------------------------------------------------
-- Widgets declarations: --
-- CPU graph
-- Initialize widget
cpuwidget = awful.widget.graph()
-- Graph properties
cpuwidget:set_width(50)
cpuwidget:set_background_color("#494B4F")
cpuwidget:set_color("#FF5656")
cpuwidget:set_gradient_colors({ "#FF5656", "#88A175", "#AECF96" })
-- Register widget
vicious.register(cpuwidget, vicious.widgets.cpu, "$1")

-- MPD Status
-- Initialize widget
mpdwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(mpdwidget, vicious.widgets.mpd,
    function (widget, args)
        if args["{state}"] == "Stop" then 
            return " - "
        else 
            return args["{Artist}"]..' - '.. args["{Title}"]
        end
    end, 10)

-- Memory status bar
-- Initialize progressbar memory widget
memwidget = awful.widget.progressbar()
-- Progressbar properties
memwidget:set_width(8)
memwidget:set_height(10)
memwidget:set_vertical(true)
memwidget:set_background_color("#494B4F")
memwidget:set_border_color(nil)
memwidget:set_color("#AECF96")
memwidget:set_gradient_colors({ "#AECF96", "#88A175", "#FF5656" })
-- Register widget
vicious.register(memwidget, vicious.widgets.mem, "$1", 13)


-- Battery stuffs
batteries = 2
-- Function to extract charge percentage
function read_battery_life(number)
   return function(format)
             local fh = io.popen('acpi')
             local output = fh:read("*a")
             fh:close()

             count = 0
             for s in string.gmatch(output, "(%d+)%%") do
                if number == count then
                   return {s}
                end
                count = count + 1
             end
          end
end
-- Display one vertical progressbar per battery
for battery=0, batteries-1 do
   batterygraphwidget = widget({ type = 'progressbar',
                                 name = 'batterygraphwidget',
                                 align = 'right' })
   batterygraphwidget.height = 0.85
   batterygraphwidget.width = 8
   batterygraphwidget.bg = '#333333'
   batterygraphwidget.border_color = '#0a0a0a'
   batterygraphwidget.vertical = true
   batterygraphwidget:bar_properties_set('battery',
                                         { fg = '#AEC6D8',
                                           fg_center = '#285577',
                                           fg_end = '#285577',
                                           fg_off = '#222222',
                                           vertical_gradient = true,
                                           horizontal_gradient = false,
                                           ticks_count = 0,
                                           ticks_gap = 0 })

   wicked.register(batterygraphwidget, read_battery_life(battery), '$1', 1, 'battery')
end
------------------------------------------------------------------------

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] =
        awful.widget.prompt({layout = awful.widget.layout.leftright})
    -- Create an imagebox widget which will contains an icon indicating which
    -- layout we're using.  We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
            awful.button({}, 1, function() awful.layout.inc(layouts, 1) end),
            awful.button({}, 3, function() awful.layout.inc(layouts, -1) end),
            awful.button({}, 4, function() awful.layout.inc(layouts, 1) end),
            awful.button({}, 5, function() awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist.new(s,
                                            awful.widget.taglist.label.all,
                                            mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist.new(function(c)
                        return awful.widget.tasklist.label.currenttags(c, s)
                    end,
                                              mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({position = "top", screen = s})
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
        s == 1 and mysystray or nil,
        s == 1 and batterygraphwidget or nil,
        s == 1 and cpuwidget  or nil,
        s == 1 and mpdwidget or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
        }

    mywibox[s].screen = s
end

-- SHIFTY: initialize shifty
-- the assignment of shifty.taglist must always be after its actually
-- initialized with awful.widget.taglist.new()
shifty.taglist = mytaglist
shifty.init()

-- Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({}, 3, function() mymainmenu:toggle() end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))

-- Key bindings
globalkeys = awful.util.table.join(
    -- Tags
    awful.key({modkey,}, "Left", awful.tag.viewprev),
    awful.key({modkey,}, "Right", awful.tag.viewnext),
    awful.key({modkey,}, "Escape", awful.tag.history.restore),

    -- Shifty: keybindings specific to shifty
    awful.key({modkey, "Shift"}, "d", shifty.del), -- delete a tag
    awful.key({modkey, "Shift"}, "n", shifty.send_prev), -- client to prev tag
    awful.key({modkey}, "n", shifty.send_next), -- client to next tag
    awful.key({modkey, "Control"},
              "n",
              function()
                  local t = awful.tag.selected()
                  local s = awful.util.cycle(screen.count(), t.screen + 1)
                  awful.tag.history.restore()
                  t = shifty.tagtoscr(s, t)
                  awful.tag.viewonly(t)
              end),
    awful.key({modkey}, "a", shifty.add), -- creat a new tag
    awful.key({modkey,}, "r", shifty.rename), -- rename a tag
    awful.key({modkey, "Shift"}, "a", -- nopopup new tag
    function()
        shifty.add({nopopup = true})
    end),

    awful.key({modkey,}, "j",
    function()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({modkey,}, "k",
    function()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({modkey,}, "w", function() mymainmenu:show(true) end),

    -- Layout manipulation
    awful.key({modkey, "Shift"}, "j",
        function() awful.client.swap.byidx(1) end),
    awful.key({modkey, "Shift"}, "k",
        function() awful.client.swap.byidx(-1) end),
    awful.key({modkey, "Control"}, "j", function() awful.screen.focus_relative( 1) end),
    awful.key({modkey, "Control"}, "k", function() awful.screen.focus_relative(-1) end),
    -- awful.key({modkey, "Control"}, "j", function() awful.screen.focus(1) end),
    -- awful.key({modkey, "Control"}, "k", function() awful.screen.focus(-1) end),
    awful.key({modkey,}, "u", awful.client.urgent.jumpto),
    awful.key({modkey,}, "Tab",
    function()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end),

    -- Standard program
    awful.key({modkey,}, "Return", function() awful.util.spawn(terminal) end),
    awful.key({modkey, "Control"}, "r", awesome.restart),
    awful.key({modkey, "Shift"}, "q", awesome.quit),

    awful.key({modkey,}, "l", function() awful.tag.incmwfact(0.05) end),
    awful.key({modkey,}, "h", function() awful.tag.incmwfact(-0.05) end),
    awful.key({modkey, "Shift"}, "h", function() awful.tag.incnmaster(1) end),
    awful.key({modkey, "Shift"}, "l", function() awful.tag.incnmaster(-1) end),
    awful.key({modkey, "Control"}, "h", function() awful.tag.incncol(1) end),
    awful.key({modkey, "Control"}, "l", function() awful.tag.incncol(-1) end),
    awful.key({modkey,}, "space", function() awful.layout.inc(layouts, 1) end),
    awful.key({modkey, "Shift"}, "space",
        function() awful.layout.inc(layouts, -1) end),
    awful.key({ modkey,           }, "=",           function () awful.util.spawn(volume_up_cmd) end),
    awful.key({ modkey,           }, "-",           function () awful.util.spawn(volume_down_cmd) end),
    awful.key({ modkey,           }, "KP_Add",      function () awful.util.spawn(volume_up_cmd) end),
    awful.key({ modkey,           }, "KP_Subtract", function () awful.util.spawn(volume_down_cmd) end),
    awful.key({ modkey,           }, "Pause",       function () awful.util.spawn("mpc toggle") end),
    awful.key({ modkey,           }, "KP_Enter",    function () awful.util.spawn("mpc toggle") end),
    awful.key({ modkey,           }, "KP_Multiply", function () awful.util.spawn("mpc next") end),
    awful.key({ modkey,           }, "KP_Divide",   function () awful.util.spawn("mpc prev") end),
    awful.key({ modkey,           }, "Next",        function () awful.util.spawn("mpc next") end),
    awful.key({ modkey,           }, "Prior",       function () awful.util.spawn("mpc prev") end),
    awful.key({ modkey,           }, "x",           function () awful.util.spawn(xlock_cmd) end),

    -- Prompt
    awful.key({modkey}, "F1", function()
        awful.prompt.run({prompt = "Run: "},
        mypromptbox[mouse.screen].widget,
        awful.util.spawn, awful.completion.shell,
        awful.util.getdir("cache") .. "/history")
        end),

    awful.key({modkey}, "F4", function()
        awful.prompt.run({prompt = "Run Lua code: "},
        mypromptbox[mouse.screen].widget,
        awful.util.eval, nil,
        awful.util.getdir("cache") .. "/history_eval")
        end)
    )

-- Client awful tagging: this is useful to tag some clients and then do stuff
-- like move to tag on them
clientkeys = awful.util.table.join(
    awful.key({modkey,}, "f", function(c) c.fullscreen = not c.fullscreen  end),
    awful.key({modkey, "Shift"}, "c", function(c) c:kill() end),
    awful.key({modkey, "Control"}, "space", awful.client.floating.toggle),
    awful.key({modkey, "Control"}, "Return",
        function(c) c:swap(awful.client.getmaster()) end),
    awful.key({modkey,}, "o", awful.client.movetoscreen),
    awful.key({modkey, "Shift"}, "r", function(c) c:redraw() end),
    awful.key({modkey}, "t", awful.client.togglemarked),
    awful.key({modkey,}, "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- SHIFTY: assign client keys to shifty for use in
-- match() function(manage hook)
shifty.config.clientkeys = clientkeys
shifty.config.modkey = modkey

-- Compute the maximum number of digit we need, limited to 9
for i = 1, (shifty.config.maxtags or 9) do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({modkey}, i, function()
            local t =  awful.tag.viewonly(shifty.getpos(i))
            end),
        awful.key({modkey, "Control"}, i, function()
            local t = shifty.getpos(i)
            t.selected = not t.selected
            end),
        awful.key({modkey, "Control", "Shift"}, i, function()
            if client.focus then
                awful.client.toggletag(shifty.getpos(i))
            end
            end),
        -- move clients to other tags
        awful.key({modkey, "Shift"}, i, function()
            if client.focus then
                t = shifty.getpos(i)
                awful.client.movetotag(t)
                awful.tag.viewonly(t)
            end
        end))
    end

-- Set keys
root.keys(globalkeys)

-- Hook function to execute when focusing a client.
client.add_signal("focus", function(c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_focus
    end
end)

-- Hook function to execute when unfocusing a client.
client.add_signal("unfocus", function(c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
    end
end)
