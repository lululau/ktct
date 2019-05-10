require 'yaml'

module Ktct
  module Config
    def config
      return @config if @config
      config_file_name = options[:config]
      yaml = YAML.load(File.read(File.expand_path(config_file_name)))
      env = ENV['KTCT_ENV'] || yaml['default_env']
      yaml[env]
    end
  end
end
