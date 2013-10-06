#!/usr/bin/env ruby
require_relative '../lib/zlog'

FILENAME = 'example.file.log'

# configure logging to stdout, so we see what's going on
Zlog::init_stdout loglevel: :info

# configure file appender
Logging.appenders.rolling_file(
  FILENAME,
  age: 'daily',
  layout: Logging.layouts.json,
  loglevel: :debug
)
Logging.logger.root.add_appenders FILENAME

# add some log entries
log1 = Logging.logger['Log1-debug']
log2 = Logging.logger['Log2-info']
log3 = Logging.logger['Log3-warn++']

log1.debug "debugging info, this won't show up on console"
log2.info "writing some info"
log3.warn "warn me, we are getting close"
log3.error "error! nah, kidding"
log3.ok "finished with example"

# read back the file to stdout
puts "\n> cat #{FILENAME}"
puts File::read(FILENAME)