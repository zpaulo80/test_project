Given(/^true$/) do
  assert true
end

Given(/^false$/) do
  assert false, 'this step should not pass'
end

Given(/^pending$/) do
  pending
end