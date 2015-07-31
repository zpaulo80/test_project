# Methods write logs with diferent levels
# @author jose paulo martins
module Log
  require 'log4r'
  require 'colored'
  require 'log4r/formatter/patternformatter'
  require 'awesome_print'
  include Log4r

  @log = Logger.new 'log'
  @log.outputters = Outputter.stdout
  @log.level = DEBUG

  AwesomePrint.defaults = {
      :indent => 6, # Indent using 4 spaces.
      :index => true, # Display array indices.
      :html => false, # Use ANSI color codes rather than HTML.
      :multiline => true, # Display in multiple lines.
      :plain => true, # Use colors.
      :raw => false, # Do not recursively format object instance variables.
      :sort_keys => true, # Do not sort hash keys.
      :limit => false, # Limit large output for arrays and hashes. Set to a boolean or integer.
      :color => {
          :args => :pale,
          :array => :white,
          :bigdecimal => :blue,
          :class => :yellow,
          :date => :greenish,
          :falseclass => :red,
          :fixnum => :blue,
          :float => :blue,
          :hash => :pale,
          :keyword => :cyan,
          :method => :purpleish,
          :nilclass => :red,
          :rational => :blue,
          :string => :yellowish,
          :struct => :pale,
          :symbol => :cyanish,
          :time => :greenish,
          :trueclass => :green,
          :variable => :cyanish
      }
  }

  # Print messages in debug level
  # @param message [String] message to print
  def self.debug (message)
    @log.debug "[#{format_date}]: "+ message.awesome_inspect
  end

  # Print messages in info level
  # @param message [String] message to print
  def self.info (message)
    @log.info "[#{format_date}]: "+ message.awesome_inspect.green
  end

  # Print messages in warn level
  # @param message [String] message to print
  def self.lwarn (message)
    @log.warn "[#{format_date}]: "+ message.awesome_inspect.purple
  end

  # Print messages in error level
  # @param message [String] message to print
  def self.error (message)
    @log.error "[#{format_date}]: "+ message.awesome_inspect.red
  end

  # Print messages in fatal level
  # @param message [String] message to print
  def self.fatal (message)
    @log.fatal "[#{format_date}]: "+ message.awesome_inspect.red
  end

  # Format date to specific format
  # @return [String] Date formatted to format %Y-%m-%d %H:%M:%S,%L
  def self.format_date
    return Time.now.strftime '%Y-%m-%d %H:%M:%S,%L'
  end
end