When /^I wait for (\d+) second$/ do |n|
  sleep(n.to_i)
end

Then /^I should see node "([^"]*)"$/ do |title|
  Then %{I should see "#{title}" within "div#tree"}
end

Then /^I should not see node "([^"]*)"$/ do |title|
  Then %{I should not see "#{title}" within "div#tree"}
end

When /^I reload the page$/ do
  When %Q{I go to the home page}
  And %Q{I wait for ajax call complete}
end

Given /^I wait for ajax call complete$/ do
  timeout = 10
  wait_until(timeout) do
    ajax_in_progress = Capybara.current_session.evaluate_script <<-JS
      Rwiki.ajaxCallInProgress;
    JS

    !ajax_in_progress
  end
end

When /^I double click node "([^"]*)"$/ do |path|
  node_id = Capybara.current_session.evaluate_script <<-JS
    Rwiki.treePanel.findNodeByPath('#{path}').id;
  JS

  Capybara.current_session.execute_script <<-JS
    $("div[ext\\\\:tree-node-id='#{node_id}']").trigger("dblclick")
  JS
end

When /^I click node "([^"]*)"$/ do |path|
  node_id = Capybara.current_session.evaluate_script <<-JS
    Rwiki.treePanel.findNodeByPath('#{path}').id;
  JS

  Capybara.current_session.execute_script <<-JS
    $("div[ext\\\\:tree-node-id='#{node_id}']").trigger("click");
  JS
end

When /^I right click node "([^"]*)"$/ do |path|
  Capybara.current_session.execute_script <<-JS
    var node = Rwiki.treePanel.findNodeByPath('#{path}')
    Rwiki.treePanel.fireEvent('contextmenu', node, { getXY: function() { return [0, 0] } });
  JS
end

Then /^I should have the following open tabs:$/ do |table|
  actual_table = table(tableish("div.x-tab-panel ul li[@class!='x-tab-edge']", "a.x-tab-right"))
  table.diff!(actual_table)
end

Then /^I should have no open tabs$/ do
  page.all("div.x-tab-panel ul li[class!='x-tab-edge']").size.should == 0
end

Then /^I should see dialog box titled "([^"]*)"$/ do |title|
  %Q{Then I should see "#{title}" within "span.x-window-header-text"}
end

When /^I fill in the dialog box input with "([^"]*)"$/ do |text|
  field = find("div.x-window-dlg input")
  field.set(text)
end

When /^I close tab for page "([^"]*)"$/ do |path|
  tab_id = Capybara.current_session.evaluate_script <<-JS
    Rwiki.tabPanel.findTabByPagePath('#{path}').tabEl.id;
  JS

  close_button = find("li##{tab_id} a.x-tab-strip-close")
  # TODO try fix this workaround see http://groups.google.com/group/ruby-capybara/browse_thread/thread/985b123dc98d27b5
  close_button.click rescue nil
end

When /^I click tab for page "([^"]*)"$/ do |path|
  tab_id = Capybara.current_session.evaluate_script <<-JS
    Rwiki.tabPanel.findTabByPagePath('#{path}').tabEl.id;
  JS

  tab = find("li##{tab_id}")
  tab.click
end
