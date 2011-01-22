Then /^I should see the node titled "([^"]*)"$/ do |title|
  Then %{I should see "#{title}" within "div#tree"}
end

Then /^I should not see the node titled "([^"]*)"$/ do |title|
  Then %{I should not see "#{title}" within "div#tree"}
end

When /^I double click (the node with path "(?:[^"]*)")$/ do |tree_node_id|
  Capybara.current_session.execute_script <<-JS
    $("div[ext\\\\:tree-node-id='#{tree_node_id}']").trigger("dblclick")
  JS
end

When /^I click (the node with path "(?:[^"]*)")$/ do |tree_node_id|
  Capybara.current_session.execute_script <<-JS
    $("div[ext\\\\:tree-node-id='#{tree_node_id}']").trigger("click");
  JS

  And %{I wait for load an ajax call complete}
end

When /^I right click the node with path "([^"]*)"$/ do |path|
  Capybara.current_session.execute_script <<-JS
    var node = Rwiki.treePanel.findNodeByPath('#{path}')
    Rwiki.treePanel.fireEvent('contextmenu', node, { getXY: function() { return [0, 0] } });
  JS
end

Then /^(the node with path "(?:[^"]*)") should be selected$/ do |tree_node_id|
  div_id = Capybara.current_session.evaluate_script <<-JS
    $('div[ext\\\\:tree-node-id="#{tree_node_id}"]').attr('id');
  JS

  page.has_css? "div##{div_id}.x-tree-selected"
end

Then /^(the node with path "(?:[^"]*)") should not be selected$/ do |tree_node_id|
  div_id = Capybara.current_session.evaluate_script <<-JS
    $('div[ext\\\\:tree-node-id="#{tree_node_id}"]').attr('id');
  JS

  page.has_no_css? "div##{div_id}.x-tree-selected"
end
