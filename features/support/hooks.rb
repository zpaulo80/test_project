# -*- encoding : utf-8 -*-

After do |scenario|
  if scenario.status.to_s == 'passed'
    Log.debug "Scenario [#{scenario.name.to_s}] status is" + " #{scenario.status.to_s}".upcase!
  else
    Log.error "Scenario [#{scenario.name.to_s}] status is #{scenario.status.to_s}".upcase!
  end

  # add test to testlist
  $test_run.list << RTest.new(scenario.name, scenario.status, $test_run.saved_values[:test_id])

  # reset test_run saved values
  $test_run.reset
end




Before do |scenario|
  # identify test_id
  generic_test_regex=/^@TEST_ID_\d+$/
  has_id_match_data = scenario.source_tag_names.select { |m| (m.match generic_test_regex) }

  has_id = !has_id_match_data.empty?
  if has_id
    $test_run.saved_values[:test_id] = has_id_match_data[0].gsub('@','')
  else
    Log.error "NO Test ID Tag was given!!!!!"
    raise Exceptions::NoTestIdTagError.new "No Test ID tag was given for this scenario: #{scenario.name}"
  end
  
  Log.info "Scenario name: #{scenario.name.to_s}. With Id: #{$test_id}".upcase!
end






at_exit do
  Log.debug 'Hook - at_exit'
  Log.debug 'Test List:'
  Log.debug $test_run.list

  Log.debug "Will remove folder #{$test_run.working_dir}"
  Dir.delete($test_run.working_dir)
  Dir.foreach('/tmp') do |folder|

    if folder.match(/d\d{8}\-\d{5}\-\w+/)
      Log.lwarn 'Other test_run folders exist... will be removed'
      Log.debug "Will remove folder #{File.join('/tmp/',folder)}"
      Dir.delete(File.join('/tmp/',folder))
    end
  end

  Log.debug '=============================================================================='
  Log.debug '============================ Stop running Features ==========================='
  Log.debug '=============================================================================='
end