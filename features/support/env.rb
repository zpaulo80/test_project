# -*- encoding : utf-8 -*-
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'testHelper', 'log')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'testHelper', 'test')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'testHelper', 'exceptions')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'testHelper', 'config')


# Start TestRun
$test_run = TestRun.new
$test_run.start_tests

require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'lib_require')


# ENV['http_proxy'] = 'http://10.112.15.158:8080'
# ENV['https_proxy'] = 'https://10.112.15.158:8080'