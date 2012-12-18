# zlog

Very rudimentary but nice logging, focusing on commandline and simplicity.

* supports continuous logging (eg have progress-bar in commandline)
* detect commandline colors

If it's too simple, use any of the regular ruby loggers instead!

# requirements

* ruby and gems
* 256-color terminal ;)

# installation

    gem build *.gemspec && gem install *gem

# example

Code:

    require "zlog"
    Zlog.error "that didn't work"
    Zlog.ok "that went nice!"

See the `example` folder and run what's inside. Example output:

![Example image in example/example.output.png](https://raw.github.com/arlimus/zlog/master/example/example.output.png)

# info

Log-levels: `NOTHING`, `ERROR`, `OK`, `WARNING`, `INFO`, `DEBUG`
Default log-level: `WARNING` (meaning that you won't see messages from `info` by default!)

Commands: `section`, `error`, `ok`, `warning`, `info`, `debug`, `abort` (like error but exits)