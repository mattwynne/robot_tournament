require 'aruba'

Then /^I should see exactly:$/ do |expected_string|
  steps %{Then the output should contain exactly:
    """
    #{expected_string}
    """
  }
end