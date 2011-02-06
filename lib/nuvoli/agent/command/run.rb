#!/usr/bin/env ruby -wKU
# require 'excon'
require "rest_client"

class Hash
  def sanitize_keys_for_mongo
    Hash.m
    Hash.new[]
  end
end


module Nuvoli
  module Agent
    class Run < Command
      
      
      
      
      def run
        # create_pid_file_or_exit
        
        unless Config.api_key.to_s != ''
          abort usage unless $stdin.tty?
          
          puts <<-END_INTRO.gsub(/^ {8}/, "")
          === Nuvoli Installation Wizard ===
            
          You need the Nuvoli API Key displayed in the Nuvoli Settings tab.
          It looks like:
            
            xxxxxxxxxxxxxxxx
            
          Enter the Key:
          END_INTRO
          Config.api_key gets.to_s.strip
          
          puts <<-END_INTRO.gsub(/^ {8}/, "")
            
          You also need the Nuvoli node class you want this node to belong to
          It looks like:
            
            apps
            
          Enter the node class:
          END_INTRO
          Config.node_class gets.to_s.strip
            
          puts "\nRegistering this node in the Nuvoli..."
          
          
          
          ohai = Ohai::System.new
          ohai.all_plugins
          response = RestClient.post "http://#{server}/agents", {
            :api_key => Config.api_key,
            :node_class => Config.node_class,
            :ohai =>  ohai.data,
            :format => 'json'
          }

          puts response.inspect
        end
        log.info "Reporting current status..." if log
        
        log.info "Starting a check for pending chef-solo runs..." if log
            
        log.info "Starting chef-solo..." if log
      end
    end
  end
end
