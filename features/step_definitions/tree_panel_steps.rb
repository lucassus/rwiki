Transform /^the tree node "([^"]*)"$/ do |path|
  Capybara.current_session.execute_script <<-JS
    // get the ExtJS internal tree node id
    var node = Rwiki.treePanel.findNodeByPath('#{path}');
    // get the corresponding div id
    return node.ui.elNode.id;
  JS
end

When /^I expand the parent for the tree node "([^"]*)"$/ do |path|
  # TODO Here be dragons, refactor this part of the code
  path.gsub!(/^\//, '')
  parts = path.split('/')
  parts[0] = "/" + parts[0]

  parts.each_index do |i|
    partial_path = parts[0..i].join('/')

    When %{I expand the tree node "#{partial_path}"}
  end
end

When /^I expand (the tree node "(?:[^"]*)")$/ do |el_node_id|
  ec_selector = "div##{el_node_id} img.x-tree-ec-icon.x-tree-elbow-plus"
  ec_last_selector = "div##{el_node_id} img.x-tree-ec-icon.x-tree-elbow-end-plus"

  expand_node_icon = (page.all(ec_selector) | page.all(ec_last_selector)).first
  expand_node_icon.click if expand_node_icon
end

When /^I open the page "([^"]*)"$/ do |path|
  When %{I expand the parent for the tree node "#{path}"}
  And %{I click the tree node "#{path}"}
  Then %{I should see the page "#{path}"}
end

Then /^I should see the page "([^"]*)"$/ do |path|
  Then %{I should see a content for the page "#{path}"}
  And %{I should see the application title "Rwiki #{path}"}

  And %{I should see enabled "Edit page" toolbar button}
  And %{I should see enabled "Print page" toolbar button}
end

Then /^I should see the page titled "([^"]*)"$/ do |title|
  Then %{I should see "#{title}" within "div#tree"}
end

Then /^I should not see the tree node titled "([^"]*)"$/ do |title|
  Then %{I should not see "#{title}" within "div#tree"}
end

When /^I click (the tree node "(?:[^"]*)")$/ do |el_node_id|
  page.find("div##{el_node_id}").click
  And %{I wait for load the page}
end

When /^I right click (the tree node "([^"]*)")$/ do |el_node_id, path|
  element = page.find("div##{el_node_id}")
  location = element.native.location

  Capybara.current_session.execute_script <<-JS
    var node = Rwiki.treePanel.findNodeByPath('#{path}')
    var eventStub = { getXY: function() { return [#{location.x}, #{location.y}] } };
    Rwiki.treePanel.fireEvent('contextmenu', node, eventStub);
  JS
end

Then /^(the tree node "(?:[^"]*)") should be selected$/ do |el_node_id|
  page.has_css? "div##{el_node_id}.x-tree-selected"
end

Then /^(the tree node "(?:[^"]*)") should not be selected$/ do |el_node_id|
  page.has_no_css? "div##{el_node_id}.x-tree-selected"
end

When /^I move the tree node "([^"]*)" to "([^"]*)"$/ do |path, parent_path|
  Capybara.current_session.execute_script <<-JS
    var node = Rwiki.treePanel.findNodeByPath('#{path}');
    var parentNode = Rwiki.treePanel.findNodeByPath('#{parent_path}');

    parentNode.appendChild(node);
  JS
end

Then /^for (the tree node "(?:[^"]*)") I should see following nodes:$/ do |el_node_id, table|
  sleep 0.5 # wait for node the expanding animation finish
  actual_table = table(tableish("div##{el_node_id} + ul.x-tree-node-ct a", "span"))
  table.diff!(actual_table)
end

When /^I fill in the tree filter with "([^"]*)"$/ do |text|
  input_selector = 'td.x-toolbar-left input'

  field = find(input_selector)
  field.set(text)
end
