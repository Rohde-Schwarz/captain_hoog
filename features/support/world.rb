require 'pathname'

module FileWorld
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
end

World(FileWorld)
