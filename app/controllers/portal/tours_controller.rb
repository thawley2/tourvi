module Portal
  class ToursController < BaseController
    def index
      @tours = @client.tours.includes(:properties).order(tour_date: :desc)
    end

    def show
      @tour = @client.tours.includes(:properties).find(params[:id])
      @properties = @tour.properties.to_a
      @messages = @tour.messages.order(:created_at)
      @suggestions = @tour.suggestions.order(:created_at)
      @ratings = @client.ratings.where(property: @properties).index_by(&:property_id)
    end
  end
end
