module Portal
  class RatingsController < BaseController
    def create
      property = client_properties.find(params.dig(:rating, :property_id))
      rating = Rating.find_or_initialize_by(property: property, client: @client)
      rating.update(value: params.dig(:rating, :value))
      redirect_back_to_tour
    end

    def update
      rating = @client.ratings.find(params[:id])
      rating.update(value: params.dig(:rating, :value))
      redirect_back_to_tour
    end

    def destroy
      @client.ratings.find(params[:id]).destroy
      redirect_back_to_tour
    end

    private

    def client_properties
      Property.joins(:tour).where(tours: { client_id: @client.id })
    end

    def redirect_back_to_tour
      redirect_to portal_client_tour_path(@client.portal_token, params[:tour_id])
    end
  end
end
