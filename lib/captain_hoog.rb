require "captain_hoog/dependencies"
require "captain_hoog/core_ext"

module CaptainHoog

  autoload :Version,      'captain_hoog/version'
  autoload :Errors,       'captain_hoog/errors/dsl_errors'
  autoload :Delegatable,  'captain_hoog/delegatable'
  autoload :HelperTable,  'captain_hoog/helper_table'
  autoload :Env,          'captain_hoog/env'
  autoload :Git,          'captain_hoog/git'
  autoload :Plugin,       'captain_hoog/plugin'
  autoload :PreGit,       'captain_hoog/pre_git'
  autoload :PluginList,   'captain_hoog/plugin_list'
  autoload :Struct,       'captain_hoog/struct/hoog_struct'
  autoload :Hoogfile,     'captain_hoog/hoogfile'
  autoload :Cli,          'captain_hoog/cli'

  module_function
  def treasury_path
    File.join(Dir.home, '.hoog', 'treasury')
  end
end
