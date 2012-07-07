#!/usr/bin/env ruby

require "zlog"

Zlog::level = Zlog::DEBUG

["debug", "log","info","warning","error","ok"].each do |m|
  Zlog::send m, "call Zlog::#{m}"
end
