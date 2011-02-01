Then /^I enter the break point$/ do
  debugger
  p 'debugger'
end

Given /^this scenario is pending$/ do
  pending # always
end

When /^I open the application$/ do
  When %Q{I go to the home page}
end

When /^I reload the application$/ do
  Capybara.current_session.execute_script <<-JS
    window.location.reload();
  JS
end

When /^I open the application for page with path "([^"]*)"$/ do |path|
  visit('/#' + path)
end

Then /^I should see dialog box titled "([^"]*)"$/ do |title|
  %Q{Then I should see "#{title}" within "span.x-window-header-text"}
end

Then /^I should see page title "([^"]*)"$/ do |title|
  find("title").text.should == title
end

When /^I create a new page titled "([^"]*)" for the node with path "([^"]*)"$/ do |title, path|
  When %{I right click the node with path "#{path}"}
  And %{I follow "Create page"}
  Then %{I should see dialog box titled "Create page"}

  When %{I fill in the input with "#{title}" within the dialog box}
  And %{I press "OK" within the dialog box}
  Then %{I should see the node titled "#{title}"}
end

Then /^I should see generated content for the node with path "([^"]*)"$/ do |path|
  sanitize = lambda { |html| html.gsub(/([^>]*)(?=<[^>]*?>)/im, '') }

  wiki_page_html = sanitize.call Rwiki::Models::Page.new(path).to_html
  page_html = sanitize.call Nokogiri::HTML(page.body).css('div.page-container:not(.x-hide-display)').first.inner_html

  page_html.should == wiki_page_html
end
