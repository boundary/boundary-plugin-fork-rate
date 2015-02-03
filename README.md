Boundary Forking Rate Plugin
----------------------------
Tracks the fork rate on your server by polling `/proc/stat`. On a busy production box you can expect a rate of somewhere between 1-10/sec, if there is a rate approaching 100/sec then your server is experiencing issues.

### Prerequisites

|     OS    | Linux | Windows | SmartOS | OS X |
|:----------|:-----:|:-------:|:-------:|:----:|
| Supported |   v   |    v    |    v    |  v   |


|  Runtime | node.js | Python | Java |
|:---------|:-------:|:------:|:----:|
| Required |    +    |        |      |

- [How to install node.js?](https://help.boundary.com/hc/articles/202360701)
- Requires access to /proc/stat 

### Plugin Setup
1. Verify that you are able to get output by running the following:
     ```bash
     $ cat /proc/stat
     ```
2. If there is no output, then this plugin will not work.

#### Plugin Configuration Fields
|Field Name  |Description                                |
|:-----------|:------------------------------------------|
|Poll Seconds|How often should the plugin poll /proc/stat|

### Metrics Collected
|Metric Name    |Description                            |
|:--------------|:--------------------------------------|
|Fork Rate / sec|the rate at which processes are growing|

### References
[Bitly - 10 Things We Forgot to Monitor](http://word.bitly.com/post/74839060954/ten-things-to-monitor)
