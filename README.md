# TrueSight Pulse Forking Rate Plugin

Tracks the fork rate on your server by polling `/proc/stat`. On a busy production box you can expect a rate of somewhere between 1-10/sec, if there is a rate approaching 100/sec then your server is experiencing issues.

### Prerequisites

|     OS    | Linux | Windows | SmartOS | OS X |
|:----------|:-----:|:-------:|:-------:|:----:|
| Supported |   v   |         |         |      |

#### TrueSight Pulse Meter versions v4.2 or later

- To install new meter go to Settings->Installation or [see instructions](https://help.truesight.bmc.com/hc/en-us/sections/200634331-Installation).
- To upgrade the meter to the latest version - [see instructions](https://help.truesight.bmc.com/hc/en-us/articles/201573102-Upgrading-the-Boundary-Meter). 

#### TrueSight Pulse Meter versions earlier than v4.2

|  Runtime | node.js | Python | Java |
|:---------|:-------:|:------:|:----:|
| Required |    v    |        |      |

- [How to install node.js?](https://help.truesight.bmc.com/hc/en-us/articles/202360701)
- Requires access to /proc/stat 

### Plugin Setup

1. Verify that you are able to get output by running the following:
     ```bash
     $ cat /proc/stat
     ```
2. If there is no output, then this plugin will not work.

#### Plugin Configuration Fields

#### All Versions

|Field Name  |Description                                |
|:-----------|:------------------------------------------|
|Poll Interval|How often should poll /proc/stat (in milliseconds)|

### Metrics Collected

|Metric Name    |Description                            |
|:--------------|:--------------------------------------|
|Fork Rate / sec|the rate at which processes are growing|

### Dashboards

None

### References

[Bitly - 10 Things We Forgot to Monitor](http://word.bitly.com/post/74839060954/ten-things-to-monitor)
