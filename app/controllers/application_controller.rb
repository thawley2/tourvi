class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :authenticate_agent!
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :pending_suggestions_count, :unread_notifications_count

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name ])
  end

  private

  def pending_suggestions_count
    return 0 unless agent_signed_in?

    Suggestion.pending.where(tour: current_agent.tours).count
  end

  def unread_notifications_count
    return 0 unless agent_signed_in?

    current_agent.notifications.unread.count
  end
end
