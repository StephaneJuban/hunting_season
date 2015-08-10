Gem::Specification.new do |s|
  s.name          = "hunting_season"
  s.version       = File.open(File.dirname(__FILE__) + '/VERSION').read.strip
  s.licenses      = ['MIT']
  s.description   = %q{Ruby gem which interfaces with Product Hunt's official REST API (api.producthunt.com). This gem is a work-in-progress which allows for calls to some of the offical API's endpoints (see README).}
  s.summary       = %q{Ruby interface to producthunt.com's offical REST API.}
  s.authors       = ["Mike Jarema"]
  s.email         = %q{mike@jarema.com}
  s.files         = Dir.glob("{lib}/**/*") + %w(LICENSE README.md VERSION)
  s.homepage      = %q{https://github.com/mikejarema/hunting_season}
  s.require_paths = ["lib"]

  s.add_runtime_dependency "httparty", '~> 0'
  s.add_runtime_dependency "rake", '~> 10'

  s.add_development_dependency "rspec", '~> 3'
  s.add_development_dependency "webmock", "~> 1"
end
