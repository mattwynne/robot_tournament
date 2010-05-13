After do |scenario|
  if scenario.failed?
    save_and_open_page
  end
end

Dir['capybara-*'].each { |f| FileUtils.rm(f) }
