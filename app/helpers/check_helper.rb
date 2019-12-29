# frozen_string_literal: true

module CheckHelper
  def format_type_enum_for_select(check)
    check.type_enum.map { |v| [v, v] }.freeze
  end

  def format_select_for_httpmethod(check)
    Check::HTTP_METHODS.map { |v| [v, v] }
  end

  def hide_form_for_check_type(check, type)
    if check.persisted?
      return check.type == type ? '' : 'is-hidden'
    end

    'is-hidden'
  end

  def first_dow_one_year_ago
    d = Time.current.end_of_week
    d - 364.days
  end
end
