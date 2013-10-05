lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require 'zlog'

spec = Gem::Specification.new do |s|
  s.name = 'zlog'
  s.version = Zlog::VERSION
  s.platform = Gem::Platform::RUBY
  s.summary = "rudimentary simple logging for ruby"
  s.description = s.summary
  s.author = "Dominik Richter"
  s.email = "dominik.richter@googlemail.com"
  s.licenses = ["MPLv2"]
  s.homepage = "https://github.com/arlimus/zlog"
  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'logging', '~> 1.8.1'

  s.files = `git ls-files`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
