When /^I fill in the input with "([^"]*)" within the dialog box$/ do |text|
  input_selector = 'div.x-window input'

  field = find(input_selector)
  field.set(text)

  # fire keyup event for trigger the autocomplete
  Capybara.current_session.execute_script <<-JS
    $("#{input_selector}").focus().trigger($.Event('keyup'));
  JS
end

When /^I press "([^"]*)" within the dialog box$/ do |button|
  When %{I press "#{button}" within "div.x-window"}
end

Then /^I should see the window titled "([^"]*)"$/ do |title|
  page.find("span.x-window-header-text").text.should == title
end

Then /^I should not see the window$/ do
  page.should have_no_css('div.x-window', :visible => true)
end
