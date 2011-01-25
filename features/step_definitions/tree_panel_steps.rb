When /^I expand the parent for the node with path "([^"]*)"$/ do |path|
  parts = path.split('/')[0..-2]
  parts.each_index do |i|
    partial_path = parts[0..i].join('/')

    # check if node is expanded
    is_expanded = Capybara.current_session.evaluate_script <<-JS
      node = Rwiki.treePanel.findNodeByPath('#{partial_path}').isExpanded();
    JS

    unless is_expanded
      Then %{I double click the node with path "#{partial_path}"}
    end
  end
end

When /^I open the page for the tree node with path "([^"]*)"$/ do |path|
  When %{I expand the parent for the node with path "#{path}"}
  And %{I click the node with path "#{path}"}
  And %{I should see page title "Rwiki #{path}"}
  And %{I should see generated content for the node with path "#{path}"}
end

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
