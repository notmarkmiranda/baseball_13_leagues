class EventDecorator < ApplicationDecorator
  delegate_all

  def formatted_date_and_time
    date_obj = object.created_at
    date_obj.strftime('%A, %d %b %Y at %l:%M %p %Z')
  end
end
