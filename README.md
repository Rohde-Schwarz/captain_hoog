# CaptainHoog

[![Build Status](https://travis-ci.org/GateprotectGmbH/captain_hoog.svg)](https://travis-ci.org/GateprotectGmbH/captain_hoog)

Okay. That's not such a funny gem name. But it's a reference to Git and the subject
of the gem: the Git Hooks.

<img src="http://dyxygd30hex7h.cloudfront.net/sites/www.prismaticart.com/files/PRISMATIC_ADAM.jpg" height="450">

## Installation

Add this line to your application's Gemfile:

    gem 'captain_hoog'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install captain_hoog

## Usage

### Install the hook

```
hoog install --type <GIT_HOOK_TYPE> --plugins_dir <PATH_TO_PLUGINS> --project_dir <PATH_TO_PROJECT>
```

**Please note:**  ```<PATH_TO_PLUGINS>``` and ```<PATH_TO_PROJECT>``` must be given as absolute paths.
Also make sure to run this from your git repository's root folder.

```GIT_HOOK_TYPE``` may be something like this

* pre-commit (default)
* pre-push
* pre-rebase
* pre-applypatch

If the directory where pre-git test should be done, differs from the working directory adjust:

```
--project_dir
```

to your needs. You can omit this.

```
--plugins_dir
```

is not required anymore. If it's omited it will point to the actual directory you run the install script from. It should point to the directory you store the CaptainHoog plugins.

_A note about plugin directories:_ To have more than one plugin directory used, just add as many plugin directories as you want do the ```plugins_dir``` section in the Hoogfile. You can select which plugin is called from which Git hook later by defining it in the Hoogfile.

### Removing the hook

Remove a hook by using the

```
hoog remove --type <GIT_HOOK_TYPE>
```

command.

where ```<GIT_HOOK_TYPE>``` is ```pre-commit``` by default.

### The Hoogfile

All plugin executable and ignoring power is configurable in the Hoogfile. The Hoogfile's name is ```hoogfile.yml``` and it will be installed in your Git root directory. If you install several hooks, the installer will ask you if you want to override the config file.

The Hoogfile has several sections:

* hook plugins per type
* project dir
* plugins dir

Some options are predefined from your information you provided during installation:

* project dir
* plugins dir

If this did not matches your need anymore, just pass the new paths in there.

Captain Hoog is doing nothing by default. You have explicitly define which plugins it should run or which not. You do this per hook type. E.g. for ```pre-commit```:

```
pre-commit:
  - cucumber
  - rspec
```

So the plugins named **cucumber** and **rspec** are running before your commit applies to the index.

### Migrating from pre 1.0 versions

There is no migration path from previous versions. Just re-install and adjust the Hoogfile to your previous configuration.  

### Writing plugins

A CaptainHoog plugin is written with a very simple DSL that used with the following expressions:

* ```test```
* ```message```
* ```helper```
* ```run```

Within ```test``` any stuff is done that either forces the commit to exit or
to pass. Whatever you want to do like syntax checking, code style checking -
implement it and make sure you return a boolean value.

```message``` is used to define a notification that is shown to the user if
the test **fails**. This obviously must return a String.  

You have to add a description (or name) to your plugin, this description (or name) will be used to check if the plugin should be executed or not by adding the plugins name to the section <hook plugins per type> of your Hoogfile.

```rb
git.describe 'sample' do |pre|

  pre.test do
    # do any test like code style guide, syntax checking...
    # Must return a boolean value.
  end

  pre.message do
    # Define a message string here that is shown if the test fails.
    # The message is printed out in red per default. If you don't want
    # a color pass color: :none to the helper method. Or if you want a
    # specific color, the color as symbol:
    # pre.message(color: :none) do ....
  end

end  
```

With ```helper``` you can extract some logic into a helper method that is useable anywhere
in the plugin.

```rb
git.describe 'logger' do |pre|

  pre.helper :collect_logger_outputs do
    # do something
  end

  pre.test do
    collect_logger_outputs.empty?
  end

  pre.message do
   %q{ You have some logger outputs in your code! }
  end
end
```

If you don't want to test anything before commiting or pushing thus just running
a command or something similiar, use the ```run``` method.

```rb
git.describe 'name of Git head' do |pre|

  pre.run do
    system "git show --name-only HEAD"
  end

end

```

**Plugin file structure**

A common way to organize plugins is:

```
<plugin_name>/
	- <plugin_name>.rb
	- test/
		- <plugin_name>_[spec|test].rb
```

**Plugin specific configurations**

Sometimes a plugin needs specific configurations that not match the use of a helper method. You can add plugin configurations to your Hoogfile by adding a section that is named after the plugin. Let's say there is a plugin called 'clear logs' that needs a 'truncate_line_numbers' configuration. The Hoogfile section would look like:

```yaml
clear logs:
  truncate_line_numbers: 100
```

You are able to access this configuration within your plugin by using the ```config``` method:

```rb
git.describe 'clear logs' do |pre|
  pre.run do
    system "sed -i '#{config.truncate_line_numbers},$ d' development.log"
  end
end
```

## Test Support

### Sandbox

For testing purposes, Captain Hoog uses some kind of sandboxing. You're able to use the sandbox directly (you have to do this by now for any other test frameworks than RSpec).

Using the sandbox is easy:

```ruby
sandbox = CaptainHoog::Test::Sandbox.new(plugin_code, cfg)
sandbox.run
# then have full access to the plugin by using sandbox.plugin
```

You have to pass the plugin as String or File object and a configuration hash to the sandbox.
The configuration hash might consist of a global (the ```env```) and a plugin specific configuration (marked by using the plugins name as key).

Example:

```rb
plugin_code = <<-PLUGIN
  git.describe 'foo' do |hook|
    hook.helper :foo_helper do
      config.number
    end

    hook.test do
      foo_helper
      true
    end

    hook.message do
      'Fun'
    end
  end
PLUGIN

cfg = {
	env: {
   		suppress_headline: true
   },
   plugin: {
  		foo: {
       	number: 12
       }
   }
}
sandbox = CaptainHoog::Test::Sandbox.new(plugin_code, cfg)
sandbox.run
sandbox.plugin.result[:test] # => true
sandbox.plugin.foo_helper # => 12
sandbox.plugin.result[:message] # => Fun
```

**Note** that the sandbox will not provide you some fake file system.

### Frameworks

Captain Hoog provides some small DSL for testing plugins if you're using RSpec. For the use of MiniTest (or any other testing framework, see the section below.)

### RSpec

Require test support by using

```rb
require 'captain_hoog/test'
```

There is no configuration needed, Captain Hoog will detect if you're using Rspec.

Then - as usual - add a ```describe``` block. Within this block you have access to a block helper:

```rb
with_plugin :<PLUGIN_NAME>, config: <HASH>, silence: <true|false> do
	# ....
end
```

|Argument| Description|
|:-------|:-----------|
|PLUGIN_NAME | Plugin - as String or File object (given as a ```let``` or method) |
|config | plugin configuration, see **Sandbox** section for details. |
|silence | Truthy or falsy value, silences the plugin output |

With ```with_plugin``` you have full access to the Captain Hoog plugin by using ```plugin```.

A full example:

```rb
require 'rspec'
require 'captain_hoog/test'

describe 'Test for hook' do
	let(:divide) do
    	path = File.expand_path(File.join(File.dirname(__FILE__),
                                        '..',
                                        'fixtures',
                                        'plugins',
                                        'test_plugins',
                                        'divide.rb'))
       File.new(path)
    end

    let(:config) do
    	{
       	plugin: {
          	divide: {
                divider: 12,
                compare_value: 1
              }
            }
       }
    end

    with_plugin :divide, config: :config, silence: true do
      describe 'helpers' do
        describe '#divider' do
          it 'returns 12 as Fixnum' do
            expect(plugin.divider).to eq 12
            expect(plugin.divider).to be_instance_of Fixnum
          end
        end

        describe '#check_equal' do
          it 'returns 1' do
            expect(plugin.check_equal).to be 1
          end
        end
      end

      it 'exits with true' do
        expect(plugin.result[:test]).to be true
      end
    end
end
```

### Other Test Frameworks (MiniTest, TestUnit ...)

You have to use the sandbox directly. See an example using MiniTest below.

```rb
gem 'minitest'
require 'minitest/autorun'
require 'minitest/unit'
require 'captain_hoog'
require 'captain_hoog/test'

class DividePluginTest < Minitest::Test
  def setup
  	config = {
   		env: {
      		suppress_headline: true
    	},
    	plugin: {
      		divide: {
        		divider: 12,
        		compare_value: 1
      		}
    	}
  	}
  	path = File.expand_path(File.join(File.dirname(__FILE__),
                                      '..',
                                      'fixtures',
                                      'plugins',
                                      'test_plugins',
                                      'divide.rb'))
    sandbox = ::CaptainHoog::Test::Sandbox.new(File.new(path), config)
    sandbox.run
    @plugin = sandbox.plugin
  end

  def test_helper_divider
    assert_equal @plugin.divider, 12
  end

  def test_helper_divider_class
    assert_instance_of Fixnum, @plugin.divider
  end

  def test_result
    assert_equal plugin.result[:test], true
  end
end
```

## Last stuff

Init and written by Daniel Schmidt (daniel.schmidt@gateprotect.com)

Image "Captain Hook" © 2012 Brian Patterson
