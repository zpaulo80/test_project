# encoding:utf-8
require 'tmpdir'

class TestRun
  @@list = []
  attr_accessor :saved_values, :saved_exceptions
  attr_reader :environment, :list, :config, :working_dir
  include Log

  # Constant with full path to temp folder used
  WORKING_DIR = Dir.mktmpdir
  RESET_EXCEPTION = [:build, :job_info, :list]
  # File containing the build configurations
  PROPERTIES_FILE = 'hudsonBuild.properties'

  def initialize
    @saved_values = {}
    @saved_exceptions = RESET_EXCEPTION
  end

  # Reset of TestRun instance
  #@return [Boolean]
  #@note this method clears all saved values except the defined exceptions
  def reset
    @saved_values = @saved_values.select { |key, value| @saved_exceptions.include?(key) }
    true
  end

  # Start TestRun for running tests
  #@return [TestRun]
  def start_tests(workspace_path=WORKING_DIR)
    build = {'runEnvironment' => :local}
    # Read build configurations
    file = read_build_configurations(File.join(workspace_path, PROPERTIES_FILE))
    build = build.merge(file)

    # load config folder
    @initialize = ConfigFiles::Config.new

    Log.debug 'Build Parameters'
    Log.debug build
    set(:build, build)
    set(:job_info, {:start_date => Time.now.strftime('%Y%m%d%H%M%S'),
                    :workspace => File.realpath(workspace_path)})
    Log.debug 'Config Parameters'
    Log.debug self.config
    self
  end

  def working_dir
    WORKING_DIR
  end

  # Sets TestRun#saved_values
  #@param values [Array] values to set in saved_values
  #@return [Hash] saved values
  #@note you can pass any number of arguments to this method, as long as they are even numbered
  #this method merges the result of Hash[ *values ] with @saved_values
  #@see Hash.[]
  #@see Hash#merge
  def set(*values)
    hash_to_set = Hash[*values]
    @saved_values = @saved_values.merge(hash_to_set)
  end

  # Returns the 'key' entry from TestRun#saved_values
  #@param key [Object] saved_values key
  #@return [Object] value
  #@note this method is a mapping to @saved_values
  def [](key)
    @saved_values[key]
  end

  # Changes 'key' entry in TestRun#saved_values
  #@param key [Object] saved_values key
  #@param value [Object] new value
  #@return [Object]
  #@note this method is a mapping to @saved_values
  def []=(key, value)
    @saved_values[key] = value
  end

  # Sets a new exception for TestRun#reset
  #@param key [Object] key to add to exceptions
  #@return [Array] exceptions list
  #@see TestRun#RESET_EXCEPTION
  #@see TestRun#reset
  def set_exception(key)
    @saved_exceptions << key
  end

  # Deletes an the 'key' entry from TestRun#saved_values
  #@param key [Object] saved_values key
  #@return [Object] deleted value
  #@note this method is a mapping to @saved_values
  def delete(key)
    @saved_values.delete(key)
  end

  def config
    @config = @initialize.cache
  end

  def environment
    @config = ConfigFiles::Config.environment
  end

  def list
    @@list
  end

  def get_test_by_name(name)
    @@list.each do |test|
      return test if test.name == name
    end
  end

  def size
    @@list.size
  end

  private
  # Reads the build configuration from a configuration file
  #@param file_path [String] path to file containing build properties
  #@return [Hash]
  def read_build_configurations(file_path)
    if File.exists?(file_path)
      build = File.open(file_path, 'r').map do |line|
        next if line =~ /^#/
        key, value = line.split('=')
        key_parts = key.split('.')
        key_parts[1].capitalize! unless key_parts[0] == 'build'
        key = "#{key_parts[0]}#{key_parts[1]}"
        default = (key == 'runEnvironment' ? :local : 0)
        [key.gsub('build', ''), value.chomp || default]
      end
      Hash[build]
    else
      {'summary' => 'local_run',
       'number' => '0',
       'id' => Time.now.strftime('%Y%m%d%H%M%S'),
       'jobName' => :local_run}
    end
  end

end

class RTest
  attr_accessor :name, :status

  def initialize(name, status, id)
    @name = name.to_s
    @status = status.to_s
    @id = id.to_s
    @test_start_timestamp = Time.now.utc.iso8601
  end


end