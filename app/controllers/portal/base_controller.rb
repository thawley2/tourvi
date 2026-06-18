module Portal
  # Public, token-based access for clients. No agent authentication.
  class BaseController < ApplicationController
    skip_before_action :authenticate_agent!
    layout "portal"

    before_action :set_client

    private

    def set_client
      @client = Client.find_by!(portal_token: params[:token])
    end

    def current_tour
      @client.tours.find(params[:tour_id] || params[:id])
    end
  end
end
