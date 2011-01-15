When /^I wait for (\d+) second$/ do |n|
  sleep(n.to_i)
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