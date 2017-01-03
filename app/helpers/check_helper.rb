module CheckHelper
  def format_type_enum_for_select(check)
    check.type_enum.map { |v| [v, v] }.freeze
  end
end
