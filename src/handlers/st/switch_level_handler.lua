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
local zcl_level = require "st.zigbee.zcl.clusters".Level
local st_switch_level = require "st.capabilities".switchLevel


local function switch_level_handler(_, device, command)
  local zcl_attr = zcl_level.server.commands
  local lvl = command.args.level

  -- FIXME: SET UP TRANSITION TIME AT PREFERENCES
  local transition_time = 5
  local zcl_level = math.floor(((lvl * 0xFF) / 0x64) + 0.5)

  assert(pcall(
    device.send,
    device,
    zcl_attr.MoveToLevelWithOnOff(device, zcl_level, transition_time)
  ))
end


return switch_level_handler
