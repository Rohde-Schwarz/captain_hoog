RSpec::Matchers.define :be_subclass_of do |super_class|
  match do |child_class|
    child_class.superclass == super_class
  end

  failure_message_for_should do |child_class|
    "expected the #{child_class} class to be a subclass of #{super_class}"
  end

  description do
    "expected a class to be a subclass of #{super_class}."
  end
end
