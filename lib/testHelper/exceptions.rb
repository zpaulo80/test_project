module Exceptions

  class TestRunGenericError < StandardError
  end

  # TestRun::Config Invalid Directory Error
  class InvalidDirectoryError < StandardError
  end
  # TestRun::Config Invalid Configuration Error
  class InvalidConfigurationError < StandardError
  end
  # TestRun::Config Invalid Environment Error
  class InvalidEnvironmentError < StandardError
  end
  # TestRun::Config Invalid Version Error
  class InvalidVersionError < StandardError
  end
  # TestRun::Config Invalid Cache Error
  class InvalidCacheError < StandardError
  end

  # TestRun::Invalid Test definition
  class NoTestIdTagError < StandardError
  end

end