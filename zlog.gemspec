spec = Gem::Specification.new do |s|
  s.name = 'zlog'
  s.version = '0.3'
  s.platform = Gem::Platform::RUBY
  s.summary = "rudimentary simple logging for ruby"
  s.description = s.summary
  s.author = "Dominik Richter"
  s.email = "dominik.richter@googlemail.com"

  s.add_dependency 'highline'

  s.files = `git ls-files`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
