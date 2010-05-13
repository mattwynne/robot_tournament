After do |scenario|
  if scenario.failed? and scenario.exception.is_a?(Spec::Expectations::ExpectationNotMetError)
    save_and_open_page
  end
end

Dir['capybara-*'].each { |f| FileUtils.rm(f) }
