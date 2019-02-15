# frozen_string_literal: true

module CheckHelper
  def format_type_enum_for_select(check)
    check.type_enum.map { |v| [v, v] }.freeze
  end

  def first_dow_one_year_ago
    d = Time.current.end_of_week
    d - 364.days
  end
end
