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

Then /^I should see active tab titled "([^"]*)"$/ do |title|
  page.find('li.x-tab-strip-active').text.should == title
end

Then /^I should have the following open tabs:$/ do |table|
  actual_table = table(tableish("div.x-tab-panel ul li[@class!='x-tab-edge']", "a.x-tab-right"))
  table.diff!(actual_table)
end

Then /^I should have no open tabs$/ do
  page.all("div.x-tab-panel ul li[class!='x-tab-edge']").size.should == 0
end

When /^I right click the tab with path "([^"]*)"$/ do |path|
  Capybara.current_session.execute_script <<-JS
    var tab = Rwiki.tabPanel.findTabByPagePath('#{path}');
    var eventStub = { stopEvent: function() {}, getPoint: function() { return [0, 0] } };
    Rwiki.tabPanel.fireEvent('contextmenu', Rwiki.tabPanel, tab, eventStub)
  JS
end

