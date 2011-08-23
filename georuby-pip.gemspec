require 'rake'

Gem::Specification.new do |s|
  s.name = 'georuby-pip'
  s.version = '0.1.0'

  s.platform = Gem::Platform::RUBY
  s.author = 'munshkr'
  s.email = 'munshkr@gmail.com'
  s.homepage = 'http://github.com/munshkr/georuby-pip'
  s.summary = 'A GeoRuby extension for asking whether a given point lies inside a polygon'
  s.description = 'A GeoRuby extension for asking whether a given point lies inside a polygon'

  s.add_dependency('GeoRuby', '~> 1.3.4')
  s.add_development_dependency('rake-compiler', '~> 0.7.9')

  s.files = FileList['lib/**/*.rb', 'test/**/*'].to_a
  s.extensions = FileList['ext/**/extconf.rb']
end
