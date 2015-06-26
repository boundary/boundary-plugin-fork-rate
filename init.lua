-- Copyright 2015 Boundary, Inc.
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--    http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

local framework = require('framework')
local Plugin = framework.Plugin
local FileReaderDataSource = framework.FileReaderDataSource
local math = require('math')
local uv = require('uv')

local PROC_STAT = '/proc/stat'

local params = framework.params

local ds = FileReaderDataSource:new(PROC_STAT)
local plugin = Plugin:new(params, ds)

local _last_count, _last_timestamp

local function delta(a, b)
	local na, nb = tonumber(a), tonumber(b)
	return (na and nb and math.max(na - nb, 0)) or 0
end

function plugin:onParseValues(data)
  local result = {}
  local count = string.match(data, '%s*processes%s+(%d+)%s*')
  if not count then
    self:event('critical', 'Can not parse process count')
  else 
    local count_delta = delta(count, _last_count)
    local timestamp = uv.Timer.now() / 1000.0
    local timestamp_delta = delta(timestamp, _last_timestamp)
    local rate = (timestamp_delta ~= 0) and (count_delta / timestamp_delta) or 0
    result['FORKRATE_PER_SECOND'] = rate 
    _last_count = count
    _last_timestamp = timestamp
  end

  return result
end

plugin:run()
