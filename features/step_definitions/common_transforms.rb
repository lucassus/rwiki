Transform /^the node with path "([^"]*)"$/ do |path|
  Capybara.current_session.evaluate_script <<-JS
    Rwiki.treePanel.findNodeByPath('#{path}').id;
  JS
end
