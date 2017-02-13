require 'trinity/presentor'
require 'trinity/decorator'

module ApplicationHelper
  include Trinity::Presentor
  include Trinity::Decorator

  def cp(path)
    "is-active" if current_page? path
  end
end
