# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'captain_hoog/version'

Gem::Specification.new do |spec|
  spec.name                 = "captain_hoog"
  spec.version              = CaptainHoog::VERSION
  spec.authors              = ["Daniel Schmidt"]
  spec.email                = ["daniel.schmidt@adytonsystems.com"]
  spec.summary              = %q{ Plugin based git-pre hook.}
  spec.homepage             = ""
  spec.license              = "MIT"
  spec.post_install_message = %Q{
    Thanks for installing the Pre-Git whatever hooker!

    If you don't have already, please install the hook:

    githoog install --type <GIT_HOOK_TYPE> --plugins_dir <PATH_TO_PLUGINS> \
      --project_dir <PATH_TO_PROJECT>
  }


  spec.files                = `git ls-files -z`.split("\x0")
  spec.executables          = spec.files.grep(%r{^bin/}) { |f| File.basename(f)}
  spec.test_files           = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths        = ["lib"]

  spec.add_runtime_dependency "colorize", '~> 0.7', '>= 0.7.3'
  spec.add_runtime_dependency "thor", '~> 0.19', '>= 0.19.1'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "cucumber"
  spec.add_development_dependency "aruba"
end
