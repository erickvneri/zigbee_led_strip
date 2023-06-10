-- Copyright 2023 erickvneri
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
local ZigbeeDriver = require "st.zigbee"

-- Zigbee clusters
local zcl_on_off = require "st.zigbee.zcl.clusters".OnOff
local zcl_level = require "st.zigbee.zcl.clusters".Level
local zcl_color_control = require "st.zigbee.zcl.clusters".ColorControl

-- ST capabilities
local st_switch = require "st.capabilities".switch
local st_switch_level = require "st.capabilities".switchLevel
local st_color_control = require "st.capabilities".colorControl
local st_color_temperature = require "st.capabilities".colorTemperature

-- Lifecycle handlers
local do_configure = require "lifecycles".do_configure

-- Zigbee handlers
local on_off_handler = require "handlers.zcl".on_off_handler

-- Capability handlers
local switch_handler = require "handlers.st".switch_handler
local switch_level_handler = require "handlers.st".switch_level_handler


local config = {
  supported_capabilities = {
    st_switch,
    st_switch_level,
    st_color_control,
    st_color_temperature

  },
  lifecycle_handlers = {
    init = nil,
    added = nil,
    doConfigure = do_configure
  },
  zigbee_handlers = {
    attr = {
      -- OnOff / Switch
      [zcl_on_off.ID] = {
        [zcl_on_off.attributes.OnOff.ID] = on_off_handler
      }
    }
  },
  capability_handlers = {
    -- Switch
    [st_switch.ID] = {
      [st_switch.switch.on.NAME] = switch_handler,
      [st_switch.switch.off.NAME] = switch_handler
    },
    -- Switch Level
    [st_switch_level.ID] = {
      [st_switch_level.commands.setLevel.NAME] = switch_level_handler
    }
  }
}


local driver = ZigbeeDriver("zigbee-led-strip-v0.0.1", config)
driver:run()
