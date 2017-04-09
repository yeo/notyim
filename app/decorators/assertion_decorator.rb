class AssertionDecorator < SimpleDelegator
  def human_condition
    condition_enum.fetch(check.type).fetch(condition.to_sym).downcase
  end
end
