When /^I expand the parent for the node with path "([^"]*)"$/ do |path|
  parts = path.split('/')[0..-2]
  parts.each_index do |i|
    partial_path = parts[0..i].join('/')
    
    When %{I expand the node with path "#{partial_path}"}
  end
end

When /^I expand (the node with path "(?:[^"]*)")$/ do |el_node_id|
  ec_selector = "div##{el_node_id} img.x-tree-ec-icon.x-tree-elbow-plus"
  ec_last_selector = "div##{el_node_id} img.x-tree-ec-icon.x-tree-elbow-end-plus"
  
  expand_node_icon = (page.all(ec_selector) | page.all(ec_last_selector)).first
  expand_node_icon.click if expand_node_icon
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

When /^I double click (the node with path "(?:[^"]*)")$/ do |el_node_id|
  Capybara.current_session.execute_script <<-JS
    $("div##{el_node_id}").trigger("dblclick")
  JS
end

When /^I click (the node with path "(?:[^"]*)")$/ do |el_node_id|
  page.find("div##{el_node_id}").click
end

When /^I right click the node with path "([^"]*)"$/ do |path|
  Capybara.current_session.execute_script <<-JS
    var node = Rwiki.treePanel.findNodeByPath('#{path}')
    Rwiki.treePanel.fireEvent('contextmenu', node, { getXY: function() { return [0, 0] } });
  JS
end

Then /^(the node with path "(?:[^"]*)") should be selected$/ do |el_node_id|
  page.has_css? "div##{el_node_id}.x-tree-selected"
end

Then /^(the node with path "(?:[^"]*)") should not be selected$/ do |el_node_id|
  page.has_no_css? "div##{el_node_id}.x-tree-selected"
end

When /^I move the node with path "([^"]*)" to "([^"]*)"$/ do |path, parent_path|
  Capybara.current_session.execute_script <<-JS
    var node = Rwiki.treePanel.findNodeByPath('#{path}');
    var parentNode = Rwiki.treePanel.findNodeByPath('#{parent_path}');

    parentNode.appendChild(node);
  JS
end
