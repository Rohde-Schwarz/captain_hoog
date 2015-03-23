class Hoogfile < OpenStruct

  def self.read(path)
    self.send(:new,path)
  end

  singleton_class.send(:alias_method, :config, :read)

  private_class_method :new

  def initialize(path)
    @path = path
    super(hoogfile)
  end

  def fetch(key, default = nil)
    if not self.respond_to?(key)
      raise IndexError unless default
      return default
    else
      self.public_send(key)
    end
  end

  private

  def hoogfile
    config = File.read(File.join(@path, 'hoogfile.yml'))
    data   = ERB.new(config).result
    YAML.load(data)
  end

end
