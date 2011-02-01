Transform /^the node with path "([^"]*)"$/ do |path|
  Capybara.current_session.execute_script <<-JS
    // get the ExtJS internal tree node id
    var node = Rwiki.treePanel.findNodeByPath('#{path}');
    // get the corresponding div id
    return node.ui.elNode.id;
  JS
end
