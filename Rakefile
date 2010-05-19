def announce(message)
  puts
  puts message
  puts "=" * message.length
end

def specs
  sh("spec spec --color")
end

def features
  sh("cucumber -f progress")  
end

task :default do
  announce("Testing Engine")
  specs
  features
  Dir["#{File.dirname(__FILE__)}/games/*"].each do |game|
    Dir.chdir(game) do
      announce("Testing Game '#{File.basename(game)}'")
      specs
      features
    end
  end
end