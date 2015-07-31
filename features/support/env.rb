# -*- encoding : utf-8 -*-
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'testRun', 'log')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'testRun', 'test')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'testRun', 'exceptions')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'testRun', 'config')


# Start TestRun
$test_run = TestRun.new
$test_run.start_tests

require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'lib_require')

