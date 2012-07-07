#!/usr/bin/env ruby

require "zlog"

Zlog::level = Zlog::DEBUG

def try_all()
  ["debug", "log","info","warning","error","ok"].each do |m|
    Zlog::send m, "call Zlog::#{m}"
  end
end

Zlog.section("trying defaults")
try_all()

Zlog::initialize_stdout_colors(0)
Zlog.section("set colors to 0")
try_all()

Zlog::initialize_stdout_colors(16)
Zlog.section("set colors to 16")
try_all()

Zlog::initialize_stdout_colors(256)
Zlog.section("set colors to 256")
try_all()