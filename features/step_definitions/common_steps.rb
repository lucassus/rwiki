When /^I wait for (\d+) second$/ do |n|
  sleep(n.to_i)
end

Given /^I wait for ajax call complete$/ do
  timeout = 10
  wait_until(timeout) do
    ajax_in_progress = Capybara.current_session.evaluate_script <<-JS
      Rwiki.ajaxCallInProgress
    JS

    !ajax_in_progress
  end
end

When /^I double click node "([^"]*)"$/ do |path|
  node_id = Capybara.current_session.evaluate_script <<-JS
    Rwiki.treePanel.findNodeByPath('#{path}').id
  JS

  Capybara.current_session.execute_script <<-JS
    $("div[ext\\\\:tree-node-id='#{node_id}']").trigger("dblclick")
  JS
end

When /^I click node "([^"]*)"$/ do |path|
  node_id = Capybara.current_session.evaluate_script <<-JS
    Rwiki.treePanel.findNodeByPath('#{path}').id
  JS

  Capybara.current_session.execute_script <<-JS
    $("div[ext\\\\:tree-node-id='#{node_id}']").trigger("click")
  JS
end

Then /^I should have the following open tabs:$/ do |table|
  actual_table = table(tableish("div.x-tab-panel ul li[@class!='x-tab-edge']", "a.x-tab-right"))
  table.diff!(actual_table)
end
