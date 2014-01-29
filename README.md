# Graphdat Forking Rate Plugin

**This is for Linux Only**

### Pre Reqs

**If you run the command `$ cat /proc/stat` and there is no output, this plugin will not work for you**

### Installation & Configuration

* The `Poll Seconds` is the number of seconds to wait before polling. It will default to 5 seconds.

### Tracks the fork rate on your server

By polling /proc/stat we can measure the rate of forking.  On a busy production box you can expect a rate of somewhere between 1-10/sec, if you have 100.. you have some problems.

#### Credits
[Bitly - 10 Things We Forgot to Monitor](http://word.bitly.com/post/74839060954/ten-things-to-monitor)
