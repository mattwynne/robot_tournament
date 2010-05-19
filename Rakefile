def announce(message)
  puts
  puts message
  puts "=" * message.length
end

task :default do
  announce("Testing Engine")
  sh("spec spec")
  sh("cucumber -f progress")
  Dir["#{File.dirname(__FILE__)}/games/*"].each do |game|
    Dir.chdir(game) do
      announce("Testing Game '#{File.basename(game)}'")
      sh("spec spec")
      sh("cucumber -f progress")
    end
  end
end