# CaptainHoog

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
githoog install --type <GIT_HOOK_TYPE> --plugins_dir <PATH_TO_PLUGINS> --project_dir <PATH_TO_PROJECT>
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

_A note about plugin directories:_ All plugins must be placed in one directory. You can select which plugin is called from which Git hook later by defining it in the Hoogfile.

### Removing the hook

Remove a hook by using the

```
githoog remove --type <GIT_HOOK_TYPE>
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

```message``` is used to define a notifiaction that is shown to the user if
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

## Last stuff

Init and written by Daniel Schmidt (daniel.schmidt@gateprotect.com)

Image "Captain Hook" © 2012 Brian Patterson
