module CaptainHoog
  class Hoogfile < Struct

    def self.read(path)
      self.send(:new,path)
    end

    singleton_class.send(:alias_method, :config, :read)

    private_class_method :new

    def initialize(path)
      @path = path
      super(hoogfile)
    end

    def plugins_config
      # select all plugin config into an env hash
      config = self.to_h.reduce({}) do |plugins_env_hash, (item_key, item_value)|
        unless reserved_keys.include?(item_key)
          plugins_env_hash.update(item_key => item_value)
        end
      end
      CaptainHoog::Struct.new(config)
    end
    alias_method :plugins_env, :plugins_config

    private

    def hoogfile
      config              = File.read(File.join(@path, 'hoogfile.yml'))
      data                = ERB.new(config).result
      interpreted_config  = YAML.load(data)
      raise StandardError if interpreted_config.key?(:plugins_config)
      interpreted_config
    end

    def hook_types
      @hook_types ||= YAML.load_file(File.join(File.dirname(__FILE__),
                                              'config',
                                              'hook_types.yml'))
    end

    def reserved_keys
      hook_types + %w(project_dir plugins_dir)
    end
  end
end
