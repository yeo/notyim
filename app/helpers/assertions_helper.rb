module AssertionsHelper
  def format_subject_enum_for_select(assertion)
    if assertion.check
      assertion.subject_enum
        .select { |a| a.split('.').first == assertion.check.type }
        .map { |v| [v, v] }
    else
      assertion.subject_enum.map { |v| [v, v] }
    end
  end

  def format_condition_enum_for_select(assertion)
    assertion.condition_enum.each_with_object({}) { |(k,v), h| h[k] = v.invert }
  end
end
