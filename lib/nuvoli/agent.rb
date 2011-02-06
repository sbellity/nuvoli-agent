require 'ohai'
require "mixlib/config"

module Nuvoli
  module Agent
    VERSION = "0.0.1".freeze
    CONFIG_FILE = File.join '/etc', 'nuvoli-agent.rb'
    
    class Config
      extend(Mixlib::Config)
    
      api_key  ''
      node_class  ''
    end
    
    Config.from_file CONFIG_FILE if File.exists? CONFIG_FILE
  end
end

require 'nuvoli/agent/command'
