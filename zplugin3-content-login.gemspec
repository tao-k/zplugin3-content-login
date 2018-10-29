$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "zplugin3/content/login/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "zplugin3-content-login"
  s.version     = Zplugin3::Content::Login::VERSION
  s.authors     = [""]
  s.email       = [""]
  s.homepage    = "https://github.com/tao-k/zplugin3-content-login"
  s.summary     = "Login Content for ZOMEKI v3"
  s.description = "Add Public Login to ZOMEKI v3"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails"
  s.add_dependency 'will_paginate'

  s.add_dependency 'delayed_job'
  s.add_dependency 'delayed_job_active_record'
  s.add_dependency 'delayed_job_master'


  s.add_development_dependency "pg"
end
