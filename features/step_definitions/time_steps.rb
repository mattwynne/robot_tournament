When /^(\d+) minutes pass$/ do |minutes|
  now = Time.now
  Time.stub!(:now).and_return(now + minutes.to_i * 60)
end

When /^(\d+) seconds pass$/ do |seconds|
  now = Time.now
  Time.stub!(:now).and_return(now + seconds.to_i)
end
