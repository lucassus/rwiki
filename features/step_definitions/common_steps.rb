Then /^I enter the break point$/ do
  debugger
  p 'debugger'
end

Given /^this scenario is pending$/ do
  pending # always
end

When /^I wait for (\d+) second$/ do |n|
  sleep(n.to_i)
end

Then /^I should see loading a page mask$/ do
  Then %{I should see "Loading page:" within "div.ext-el-mask-msg"}
end

When /^I wait for load the page$/ do
  condition = lambda { page.all('div.ext-el-mask-msg', :visible => true).empty? rescue true }
  sleep 0.5 # wait for the mask
  unless condition.call
    Then %{I should see loading a page mask}
    wait_until(10, &condition)
  end
  sleep 0.5 # wait for insert the page to the DOM
end

When /^I open the application$/ do
  When %Q{I go to the home page}
  Then %{I should see disabled "Edit page" toolbar button}
  And %{I should see disabled "Print page" toolbar button}

  Given %{the connection is slow}
end

When /^the connection is slow$/ do
  Capybara.current_session.execute_script <<-JS
    Rwiki.Debug.emulateSlowConnection(true);
  JS
end

When /^I reload the application$/ do
  Capybara.current_session.execute_script <<-JS
    window.location.reload();
  JS
end

When /^I open the application for page "([^"]*)"$/ do |path|
  visit('/#' + path)
  And %{I wait for load the page}
end

Then /^I should see dialog box titled "([^"]*)"$/ do |title|
  %Q{Then I should see "#{title}" within "span.x-window-header-text"}
end

Then /^I should see the application title "([^"]*)"$/ do |title|
  find("title").text.should == title
end

When /^I create a new page titled "([^"]*)" for the parent "([^"]*)"$/ do |title, path|
  When %{I right click the tree node "#{path}"}
  And %{I follow "Add page"}
  Then %{I should see dialog box titled "Add page"}

  When %{I fill in the input with "#{title}" within the dialog box}
  And %{I press "OK" within the dialog box}
  And %{I wait for load the page}
  Then %{I should see the page titled "#{title}"}
end

Then /^I should see a content for the page "([^"]*)"$/ do |path|
  require 'lorax'
  require 'ap'

  expected_html = Rwiki::Page.new(path).html_content
  expected_html = "<div>#{expected_html}</div>"
  actual_html = Nokogiri::HTML(page.body).css('div.page-container:not(.x-hide-display)').first.inner_html
  actual_html = "<div>#{actual_html}</div>"

  result = Lorax.diff(expected_html, actual_html)
  unless result.deltas.empty?
    ap result.deltas
  end
  result.deltas.should be_empty
end
