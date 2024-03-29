# frozen_string_literal: true

require_relative 'lib/actor_sync/version'

Gem::Specification.new do |spec|
  spec.name          = 'actor_sync'
  spec.version       = ActorSync::VERSION
  spec.authors       = ['Subomi']
  spec.email         = ['subomioluwalana71@gmail.com']

  spec.summary       = 'Automatically synchronise actor information to your third party systems e.g. Mixpanel, Sendgrid, etc.'
  spec.homepage      = 'https://github.com/Subomi/ActorSync'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'mixpanel-ruby'
  spec.add_runtime_dependency 'activesupport'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'listen', '~> 3.0'
  spec.add_development_dependency 'minitest', '~> 5.14'
end
