-- Pull in the wezterm API
local wezterm = require('wezterm')

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
config.color_scheme = 'Tokyo Night'
config.font = wezterm.font('JetBrains Mono')

-- TABS [BEGIN]
function tab_title(tab_info)
    local title = tab_info.tab_title
    -- if the tab title is explicitly set, take that
    if title and #title > 0 then
        return title
    end
    -- Otherwise, use the title from the active pane
    -- in that tab
    return tab_info.active_pane.title
end

wezterm.on(
    'format-tab-title',
    function(tab, tabs, panes, config, hover, max_width)
        local title = wezterm.truncate_right(tab_title(tab), max_width - 2)

        if tab.is_active then
            return {
                { Background = { Color = '#e0af68' } },
                { Foreground = { Color = '#000000' } },
                { Text = ' ' .. title .. ' ' },
            }
        else
            return {
                { Background = { Color = '#373640' } },
                { Foreground = { Color = '#ffffff' } },
                { Text = ' ' .. title .. ' ' },
            }
        end
    end
)
-- TABS [END]

-- and finally, return the configuration to wezterm
return config
