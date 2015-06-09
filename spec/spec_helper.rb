$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

ENV["PREGIT_ENV"] = "test"

require 'captain_hoog'
require 'captain_hoog/test'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |file| require file }
