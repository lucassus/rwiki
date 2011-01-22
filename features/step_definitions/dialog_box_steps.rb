When /^I fill in the input with "([^"]*)" within the dialog box$/ do |text|
  field = find('div.x-window-dlg input')
  field.set(text)
end

When /^I press "([^"]*)" within the dialog box$/ do |button|
  When %{I press "#{button}" within "div.x-window-dlg"}
  And %Q{I wait for load an ajax call complete}
end
