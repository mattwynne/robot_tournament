require 'aruba'

Then /^I should see exactly:$/ do |expected_string|
  steps %{Then the output should contain exactly:
    """
    #{expected_string}
    """
  }
end

Then /^I should see:$/ do |expected_string|
  steps %{Then the output should contain:
    """
    #{expected_string}
    """
  }
end
