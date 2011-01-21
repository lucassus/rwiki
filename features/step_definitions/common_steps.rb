When /^I open the application$/ do
  When %Q{I go to the home page}
  And %Q{I wait for load the tree}
end

When /^I reload the application$/ do
  Capybara.current_session.execute_script <<-JS
    window.location.reload();
  JS
end

When /^I open the application for page with path "([^"]*)"$/ do |path|
  visit('/#' + path)
  And %Q{I wait for load the tree}
  And %Q{I wait for load the page}
end

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

Given /^I wait for load the page$/ do
  timeout = 10
  wait_until(timeout) do
    Capybara.current_session.evaluate_script <<-JS
      Rwiki.ajaxCallCompleted;
    JS
  end
end

Then /^I should see dialog box titled "([^"]*)"$/ do |title|
  %Q{Then I should see "#{title}" within "span.x-window-header-text"}
end

Then /^I should see page title "([^"]*)"$/ do |title|
  find("title").text.should == title
end

When /^I create a new page title "([^"]*)" for the node with path "([^"]*)"$/ do |title, path|
  When %{I right click the node with path "#{path}"}
  And %{I follow "Create page"}
  Then %{I should see dialog box titled "Create page"}

  When %{I fill in the input with "#{title}" within the dialog box}
  And %{I press "OK" within the dialog box}
  Then %{I should see the node titled "#{title}"}
end
