Given /^I should see disabled "([^"]*)" toolbar button$/ do |title|
  page.find(:xpath, "//button[contains(., '#{title}')]/../../../../..[contains(@class, 'x-item-disabled')]")
end

When /^I should see enabled "([^"]*)" toolbar button$/ do |title|
  page.find(:xpath, "//button[contains(., '#{title}')]/../../../../..[not(contains(@class, 'x-item-disabled'))]")
end
