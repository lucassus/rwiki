When /^I press the browser back button$/ do
  Capybara.current_session.evaluate_script <<-JS
    history.back();
  JS
end

When /^I press the browser forward button$/ do
  Capybara.current_session.evaluate_script <<-JS
    history.forward();
  JS
end
