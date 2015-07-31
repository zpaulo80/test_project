module ConfigFiles
  require 'erb'
  require 'yaml'
  include Log
  class Config
    # Defines the configuration folder
    CONFIG_FOLDER = 'config'
    # Defines the main configuration file
    MAIN_FILE = 'main.yml'

    attr_accessor :environment, :configurations, :cache

    public
    # Creates a new Configuration manager
    def initialize
      reset
      load_configs
    end

    def load_configs(options={})
      config_folder_present?
      read_main_config if main_file_present?
      @environment = options[:environment] if options[:environment]
      raise(Exceptions::InvalidConfigurationError, 'No valid configuration for environment was found!') unless @environment

      load_env_configurations(options)
    end

    private
    # Verifies the existence of the configuration folder
    #@return [Boolean]
    def config_folder_present?
      !!config_folder_path
    rescue Errno::ENOENT
      raise(Exceptions::InvalidDirectoryError, 'Current directory does not contain a configuration folder!')
    end

    # Builds the path to the configuration folder
    #@return [String]
    def config_folder_path
      File.realpath(File.join(CONFIG_FOLDER))
    end

    # Verifies that the main configuration file is present in the configuration folder
    #@return [Boolean]
    def main_file_present?
      config_files = Dir.glob(File.join(config_folder_path, '*')).map { |file| File.basename(file) }
      unless config_files.include?(MAIN_FILE)
        raise(Exceptions::InvalidConfigurationError, "Configuration folder does not contain a '#{MAIN_FILE}' file!")
      end
      true
    end

    # Reads the main configuration file
    #@return [Hash]
    def read_main_config
      main = read_yaml_file(File.join(config_folder_path, MAIN_FILE))
      unless main and main['environment']
        raise(Exceptions::InvalidConfigurationError, "Configuration file '#{MAIN_FILE}' does not contain default environment info!")
      end
      @environment = main['environment']
      main
    end

    # Reads a YAML file
    #@param file_path [String] path to YAML file
    #@return [Hash]
    def read_yaml_file(file_path)
      YAML::load(ERB.new(File.read(file_path)).result) or {}
    rescue Psych::SyntaxError
      Log.error "Error reading YAML file #{file_path}!"
      raise
    end

    # Loads configurations for a specified environment
    #@param options [Hash] options for loading configurations
    #@return [Array] List of configuration files read
    def load_env_configurations(options)
      Log.debug "Loading environment '#{@environment}' configurations."
      files = load_config_folder(environment_folder(@environment))
      @configurations = @configurations + files
    end

    # Loads configuration files from a configuration folder
    #@param path [String] Path to configuration folder
    #@return [Array] List of configuration files read
    def load_config_folder(path)
      files = Dir.glob(File.join(path, '*.yml'))
      if files.empty?
        log.warn { 'No files .yml to load.' }
        return nil
      end
      #put configurations to a variable
      files.each { |file| file_to_cache(file) }
      files.map { |file| File.basename(file) }
    end

    # Returns the environment folder path for the given environment name
    #@return [String]
    def environment_folder(environment_name)
      unless File.exists?(File.join(config_folder_path, environment_name))
        raise(Exceptions::InvalidEnvironmentError, "Configurations for environment '#{environment_name}' don't exist!")
      end
      File.realpath(File.join(config_folder_path, environment_name))
    end

    # Reads a YAML file or collects the information from cache
    #@param file_path [String] /fullpath/to/file.yml
    #@return [Hash]
    def file_to_cache(file_path)
      file_name = file_path.match(/(\w+)\.yml/)
      raise(Exceptions::InvalidDirectoryError, "Path '#{file_path}' is not a YAML file!") unless file_name
      file_var = file_name.captures.first
      Log.debug "Loading configuration from: #{ File.basename(file_path) }"
      config = read_yaml_file(file_path)
      config = add_to_cache({ file_var => config })
      Log.debug "Loaded  configuration from: #{ File.basename(file_path) }."
      config
    end

    def add_to_cache (hash)
      @cache = @cache.merge(hash)
    end


    # Resets all Configuration manager variables
    def reset
      @cache          = {}
      @environment    = nil
      @config_path    = nil
      @configurations = []
    end

  end
end