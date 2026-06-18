class NotificationsController < ApplicationController
  def index
    @notifications = current_agent.notifications.recent
  end

  def update
    notification = current_agent.notifications.find(params[:id])
    notification.update(read: true)
    if notification.tour
      redirect_to notification.tour
    else
      redirect_back fallback_location: notifications_path
    end
  end
end
