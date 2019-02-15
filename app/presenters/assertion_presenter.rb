# frozen_string_literal: true

class AssertionPresenter < SimpleDelegator
  def condition
    c = super
    condition_enum[check.type][c]
  end

  def subject
    s = super
    s.sub '.', ' '
  end
end
