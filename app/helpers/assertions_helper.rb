# frozen_string_literal: true

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
    assertion.condition_enum.each_with_object({}) { |(k, v), h| h[k] = v.invert }
  end

  def elm_format_subject_enum_for_select(assertion)
    raise 'Check Missing' unless assertion.check

    assertion.subject_enum
             .select { |a| a.split('.').first == assertion.check.type }
             .map { |k, v| [k, v.split('.').last.sub('_', ' ')] }
  end

  def elm_format_condition_enum_for_select(assertion)
    raise 'Check Missing' unless assertion.check

    assertion.condition_enum.fetch(assertion.check.type).map { |op, text| { op: op, text: text } }
  end
end
