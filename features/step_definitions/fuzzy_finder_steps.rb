When /^I select the first search result$/ do
  search_result = page.find('div.search-item:first')
  search_result.click
end
