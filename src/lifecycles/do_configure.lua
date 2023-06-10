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
local device_mgmt = require 'st.zigbee.device_management'
local zcl_on_off = require "st.zigbee.zcl.clusters".OnOff

--
-- ::param driver ZigbeeDriver
-- ::param device Device
local function do_configure(driver, device)
  -- Ping device
  device:refresh()

  -- Bind OnOff cluster
  device:send(device_mgmt.build_bind_request(
    device,
    zcl_on_off.ID,
    driver.environment_info.hub_zigbee_eui
  ))

  -- Configure reporting
  device:send(
    zcl_on_off.attributes.OnOff:configure_reporting(device, 0, 300, 1)
  )

  -- Emit Zigbee event
  device:send(zcl_on_off.attributes.OnOff:read(device))
end


return do_configure
