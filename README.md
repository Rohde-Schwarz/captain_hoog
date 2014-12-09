# CaptainHoog

Okay. That's not such a funny gem name. But it's a reference to Git and the subject
of the gem: the Git Hooks.

![Alt text](http://dyxygd30hex7h.cloudfront.net/sites/www.prismaticart.com/files/PRISMATIC_ADAM.jpg)


## Installation

Add this line to your application's Gemfile:

    gem 'captain_hoog'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install captain_hoog
    
If the gem cannot be found in any of the sources, 
consider adding our geminabox server to your gem sources by running

    $ gem sources --add http://geminabox.lan.adytonsystems.com

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

is required and should point to the directory you store the CaptainHoog plugins.

_A note about plugin directories:_ The CaptainHoog will expect the following directory structure:

```
--<PATH_TO_PLUGIN>
 |-- pre-commit
 |-- pre-push
 |-- ..
 |-- shared
```

If you are a web-developer at gateprotect you can use the already existing and prefilled
plugin-directory located at <web-repository>/pre_git_plugins and use this as your plugins_dir.
The project_dir should then point to webgui2 since this is where rspec should be called from.

If you need plugins that should be run by any hook, place them into the ```shared``` directory. 

These options are adjustable anytime you want in ```.git/hooks/<YOUR_HOOK_FILE>```.

### Removing the hook

Remove a hook by using the

```
githoog remove --type <GIT_HOOK_TYPE>
```

command.

where ```<GIT_HOOK_TYPE>``` is ```pre-commit``` by default.

### Writing plugins

A CaptainHoog plugin is written with a very simple DSL that used with the following expressions:

* ```test```
* ```message```
* ```helper```
* ```run```

Within ```test``` any stuff is done that either forces the commit to exit or
to pass. Whatever you want to do like syntax checking, code style checking -
implement it there and make sure you return a boolean value.

```message``` is used to define a notifiaction that is shown to the user if
the test **fails**. This obviously must return a String.  

```
git do |pre|

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

```
git do |pre|

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

```
git do |pre|

  pre.run do
    system "git show --name-only HEAD"
  end

end

```

## Last stuff

Init and written by Daniel Schmidt (daniel.schmidt@adytonsystems.com)
