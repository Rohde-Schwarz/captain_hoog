module CaptainHoog
  class Cli < Thor
    include Thor::Actions

    def self.exit_on_failure?
      true
    end

    def self.source_root
      File.join(File.dirname(__FILE__), "templates")
    end

    class_option :type, type: :string, default: 'pre-commit'
    class_option :project_dir, type: :string, default: Dir.getwd
    class_option :plugins_dir, type: :string, default: Dir.getwd

    map %w[--version -v] => :__print_version

    desc "install","Installs the hook into your Git repository"
    def install(*args)
      check_if_git_present
      check_if_option_present("plugins_dir")
      init_environment
      install_hook({ as: options[:type],
                     context: {
                       root_dir: Dir.getwd,
                       plugins_dir: options[:plugins_dir],
                       project_dir: options[:project_dir]
                     }
                  })
      puts "Installed hook as #{options[:type]} hook".green
    end

    desc "remove", "Removes a hook from your Git repository"
    def remove(*args)
      check_if_git_present
      remove_hook(as: options[:type])
      puts "The #{options[:type]} hook is removed.".green
    end

    option :from, type: :string, required: true
    option :to, type: :string, required: true
    desc "move", "Moves a hook from type to another"
    def move(*args)
      check_if_git_present
      if options[:from] == options[:to]
        puts "--from and --to arguments are the same".red
        raise Thor::Error
      else
        move_hook(options)
        puts "The #{options[:from]} hook is moved to #{options[:to]} hook.".green
      end
    end

    desc "version, -v", "Prints out the version"
    def __print_version
      puts CaptainHoog::VERSION
    end

    option :home, type: :string
    desc "init", "Initializes the Captain Hoog Environment"
    def init
      home_dir = options[:home]
      init_environment(home_dir: home_dir)
    end

    private

    def is_git_repository?
     File.exists?(File.join(Dir.getwd, ".git"))
    end

    def install_hook(config)
      opts        = config[:context]
      opts[:type] = config[:as]
      copy_config_file(opts)
      template("install.erb",File.join(hooks_dir, config[:as]), opts)
      FileUtils.chmod(0755,File.join(hooks_dir, config[:as]))
    end

    def remove_hook(config)
      FileUtils.rm_rf(File.join(hooks_dir, config[:as]))
    end

    def move_hook(config)
      from = File.join(hooks_dir, config[:from])
      to   = File.join(hooks_dir, config[:to])
      FileUtils.mv(from, to)
    end

    def hooks_dir
      git_dir.join(".git", "hooks")
    end

    def git_dir
      Pathname.new(Dir.getwd)
    end

    def check_if_git_present
      if not is_git_repository?
        puts "I can't detect a Git repository".red
        raise Thor::Error
      end
    end

    def check_if_option_present(type)
      unless options.has_key?(type)
        puts "No value provided for required options '--#{type}'".red
        raise Thor::Error
      end
    end

    def copy_config_file(opts={})
      template('hoogfile.erb', git_dir.join('hoogfile.yml'), opts)
    end

    def init_environment(home_dir: Dir.home, silence: false)
      environment_dir = File.join(home_dir, '.hoog')
      treasury_dir = File.join(environment_dir, 'treasury')
      if File.exist?(treasury_dir)
        puts "Treasury already exists. Skipping.".yellow unless silence
      else
        puts "Initializing treasury".green unless silence
        FileUtils.mkdir_p(treasury_dir)
      end
    end
  end
end
