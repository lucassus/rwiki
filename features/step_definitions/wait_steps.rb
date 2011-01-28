When /^I wait for (\d+) second$/ do |n|
  sleep(n.to_i)
end

Given /^I wait for load the tree$/ do
  timeout = 10
  wait_until(timeout) do
    Capybara.current_session.evaluate_script <<-JS
      Rwiki.treeLoaded;
    JS
  end
end

Given /^I wait for an ajax call complete$/ do
  timeout = 10
  wait_until(timeout) do
    Capybara.current_session.evaluate_script <<-JS
      Rwiki.ajaxCallCompleted;
    JS
  end
end
