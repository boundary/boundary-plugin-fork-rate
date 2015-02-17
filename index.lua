-- [boundary.com] Forkrate Meter Lua Plugin
-- [author] Valeriu Paloş <me@vpalos.com>

-- Imports.
local fs = require('fs')
local io = require('io')
local json = require('json')
local math = require('math')
local timer = require('timer')
local uv = require('uv')

-- Configuration.
local PROC_STAT = '/proc/stat'

-- Initialize parameters.
local _parameters = json.parse(fs.readFileSync('param.json')) or {}

local _pollInterval =
	(_parameters.pollSeconds and tonumber(_parameters.pollSeconds) * 1000) or
	 _parameters.pollInterval or
	 5000

local _source =
	(type(_parameters.source) == 'string' and _parameters.source:gsub('%s+', '') ~= '' and _parameters.source) or
	 io.popen("uname -n"):read('*line')

-- Back-trail.
local _last_count, _last_timestamp

-- Environment check.
if not fs.existsSync(PROC_STAT) then
  error('The proc path "' .. PROC_STAT .. '" was not found. Without this file, the plugin cannot run!', 1)
end

-- Get difference (increase) between two numbers.
function delta(a, b)
	local na, nb = tonumber(a), tonumber(b)
	return (na and nb and math.max(na - nb, 0)) or 0
end

-- Parse data (i.e. line: "processes <count>").
function parse(failure, data)
  local count = tostring(data):match('%sprocesses%s+(%d+)%s')

  if failure or not count then
    fail(failure)
  else
    event(count)
  end
end

-- Schedule poll.
function schedule()
  timer.setTimeout(_pollInterval, poll)
end

-- Handle failure.
function fail(message)
  _last_count = nil
  _last_timestamp = nil
  print(message or 'Error parsing "' .. PROC_STAT .. '"!')
  schedule()
end

-- Handle event.
function event(count)
  local timestamp = uv.Timer.now() / 1000.0

  -- Not on first non-zero value.
  if _last_count then
    local count_delta = delta(count, _last_count)
    local timestamp_delta = delta(timestamp, _last_timestamp)
    local rate = (timestamp_delta ~= 0) and (count_delta / timestamp_delta) or 0

    print('FORKRATE_PER_SECOND ' .. rate .. ' ' .. _source)
  end

  _last_count = count
  _last_timestamp = timestamp
  schedule()
end

-- Get current process count.
function poll()
	local success, failure = pcall(fs.readFile, PROC_STAT, parse)

	if not success then
		fail(failure)
	end
end

-- Ready, go.
poll()