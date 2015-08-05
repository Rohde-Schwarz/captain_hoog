require 'pathname'

module FileWorld
  def executable
    'hoog'
  end

  def bin_path
    File.expand_path(File.join(File.dirname(__FILE__),
                               "..",
                               ".."))
  end

  def git_project_path
    f = File.expand_path(File.join(File.dirname(__FILE__),
                                 "..",
                                 "..",
                                 "spec",
                                 "fixtures",
                                 "with_git"))
    Pathname.new(f)
  end

  def hooks_path(type)
    path = git_project_path.join(".git",
                                 "hooks",
                                 type)
    path
  end

  def hook_config_file_path
    git_project_path.join('hoogfile.yml')
  end

  def write_file(path, file_content)
    File.open(path, 'w') { |file| file.write(file_content) }
  end

  def write_spec(name, file_content)
    spec_name = File.expand_path(File.join(File.dirname(__FILE__),
                          '..',
                          '..',
                          'spec',
                          'hooks',
                          "#{name}.rb"))
    write_file(spec_name, file_content)
  end

end

World(FileWorld)
