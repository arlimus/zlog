# zlog

Logging configuration on top of ruby's `logging` gem (see [github](https://github.com/TwP/logging)).

* colorful default logging to stdout
* supports continuous logging (eg progress indicators which you don't want to clutter your commandline)
* added section and ok log types

# requirements

* gems:
  * logging
  * highline

# installation

    gem build *.gemspec && gem install *gem

# example

Code:

    require "zlog"
    Zlog.init_stdout loglevel: :debug

    l = Logging.logger["main"]
    l.section "log demonstration"
    l.ok "ok me"
    l.debug "debug me"
    l.info "info me"
    l.warn "warn me"
    l.error "error me"
    l.fatal "fatal me"


See the `example` folder for more.

![Example image in example/example.output.png](https://raw.github.com/arlimus/zlog/master/example/example.output.png)
