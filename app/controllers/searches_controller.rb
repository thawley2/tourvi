class SearchesController < ApplicationController
  def show
    @query = params[:q].to_s.strip
    if @query.present?
      term = "%#{@query.downcase}%"
      @tours = current_agent.tours.includes(:client, :properties)
        .left_joins(:properties)
        .where("LOWER(tours.name) LIKE :t OR LOWER(properties.address) LIKE :t", t: term)
        .distinct
      @clients = current_agent.clients
        .where("LOWER(name) LIKE :t OR LOWER(email) LIKE :t", t: term)
    else
      @tours = Tour.none
      @clients = Client.none
    end
  end
end
