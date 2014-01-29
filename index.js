var _fs = require('fs');
var _os = require('os');
var _param = require('./param.json');
var _path = require('path');
var _tools = require('graphdat-plugin-tools');

var PROC_STAT = '/proc/stat';

var _pollInterval; // the interval to poll the metrics
var _previous; // the previous process count
var _previous_ts; // the previous time the metric was counted
var _source; // the source of the metrics

// ==========
// VALIDATION
// ==========

// check that the /proc/stat exists on the OS
if (!_fs.existsSync(PROC_STAT)) {
  console.error('The proc path "%s" was not found', PROC_STAT);
  console.error('Without this file, the plugin cannot run');
  process.exit(1);
}

// how often should we poll
var _pollInterval = (_param.pollSeconds && parseFloat(_param.pollSeconds) * 1000) ||
                    (_param.pollInterval) ||
                    5000;

// set the source if we do not have one
var _source = (_param.source && _param.source.trim() !== '') ? _param.source : _os.hostname();

// ===============
// LET GET STARTED
// ===============

// get the natural difference between a and b
function diff(a, b) {
  if (a == null || b == null || isNaN(a) || isNaN(b))
    return 0;
  else
    return Math.max(a - b, 0);
}

// read /proc/stat and get the process count
function getProcessCount(cb)
{
  /*
    --- sample /proc/stat config ---
    cpu  219523134 96452 61160415 8079132467 5473655 618 4674630 269968445 0 0
    cpu0 219523134 96452 61160415 8079132467 5473655 618 4674630 269968445 0 0
    intr 2114458164 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1638452663 0 0 0 0 0 735 61 41918208 2023 1457450 432627024 0 0 0 .. 0
    ctxt 15497507466
    btime 1345222824
    processes 65684390
    procs_running 1
    procs_blocked 0
    softirq 10753104320 0 1300777661 2692326013 3285370968 0 0 1 0 860210 3473769467
    --------------------------------
  */

  try {
    var now = Date.now();
    _fs.readFile(PROC_STAT, {encoding: 'utf8'}, function(err, lines) {
      if (err)
        return cb(err);
      if (!lines)
        return cb(null);

      var match = lines.toString().match(/processes\s+(\d+)/);
      if (!match)
        return cb(null);

      var processCount = match[1];
      return cb(null, processCount, now);
    });
  }
  catch(e) {
    return cb(e);
  }
}

// get the stats, format the output and send to stdout
function poll(cb)
{
  getProcessCount(function(err, current, ts) {

    if (err || current === undefined) {
      _previous = undefined;
      _previous_ts = undefined;
      console.error(err || 'Error parsing ' + PROC_STAT);
      setTimeout(poll, _pollInterval);
      return;
    }
    if (_previous === undefined) {
      // skip the first value otherwise it would be 0
      _previous = current;
      _previous_ts = ts;
      setTimeout(poll, _pollInterval);
      return;
    }

    var delta = diff(current, _previous);
    var ts_delta= diff(ts, _previous_ts);
    var rate = (ts_delta) ? delta/ts_delta : 0;

    console.log('FORKRATE_PER_SECOND %d %s', rate, _source);

    _previous = current;
    _previous_ts = ts;
    setTimeout(poll, _pollInterval);
  });
}
poll();
