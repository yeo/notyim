require 'trinity/presentor'
require 'trinity/decorator'
require 'trinity/current'

module ApplicationHelper
  include Trinity::Presentor
  include Trinity::Decorator

  def cp(path)
    "is-active" if current_page? path
  end

  def current
    Trinity::Current.current
  end
end
