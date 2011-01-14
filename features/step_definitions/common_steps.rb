When /^I click node "([^"]*)"$/ do |path|
  p Capybara.current_session.evaluate_script("Rwiki.treePanel.findNodeByPath('#{path}')")
end
