# Marking every notification read is modeled as updating the "all read" state.
class NotificationReadsController < ApplicationController
  def update
    current_agent.notifications.unread.update_all(read: true)
    redirect_back fallback_location: notifications_path
  end
end
