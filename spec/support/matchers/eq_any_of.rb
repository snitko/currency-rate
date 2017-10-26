RSpec::Matchers.define :eq_any_of do |values|
  match { |actual| values.include? actual }
end
