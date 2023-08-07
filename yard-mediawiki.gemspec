Gem::Specification.new do |s|
  s.name          = "yard-mediawiki"
  s.summary       = "Template and Plugin to render output in Mediawiki syntax"
  s.description   = "Fooo"
  s.version       = "0.0.1.1"
  s.author        = "Lupino"
  s.platform      = Gem::Platform::RUBY
  s.files         = Dir['{lib,templates}/**/*', 'CHANGELOG.md', 'LICENSE', 'README.md']
  s.require_paths = ['lib']
  s.license = 'MIT' if s.respond_to?(:license=)
end
