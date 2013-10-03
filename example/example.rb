#!/bin/ruby
require_relative '../lib/zlog'

Zlog.init_stdout loglevel: :debug

logger = Logging.logger["zlog"]
logger.section "zlog"
logger.ok "ok me"
logger.debug "debug me"
logger.info "info me"
logger.warn "warn me"
logger.error "error me"
logger.fatal "fatal me"

logger.section "continuous logging"
(1..50).each do |len|
  logger.debug( logger.cont "o"*len+"k" )
  sleep 0.01
end
logger.info "back to normal"

logger.section "logging with hierarchies"
Zlog.init_stdout named: true, loglevel: :debug
foo = Logging.logger['Foo']
bar = Logging.logger['Foo::Bar']
baz = Logging.logger['Foo::Baz']
foo.debug 'foo will send a warning soon'
foo.warn 'this is a warning, not a ticket'
bar.info 'this message will not be logged'
baz.info 'nor will this message'
bar.ok 'bar ís ok'
bar.error 'but this error message will be logged'

logger.section "show logger configuration"
Logging.show_configuration