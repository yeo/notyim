module AssertionsHelper
  def format_subject_enum_for_select(assertion)
    assertion.subject_enum.map { |v| [v, v] }.freeze
  end

  def format_condition_enum_for_select(assertion)
    assertion.condition_enum.each_with_object({}) { |(k,v), h| h[k] = v.invert }
  end
end
