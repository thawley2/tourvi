class SuggestionsController < ApplicationController
  def index
    @suggestions = agent_suggestions.includes(:client, :tour).order(created_at: :desc)
  end

  def update
    suggestion = agent_suggestions.find(params[:id])
    case params[:decision]
    when "approve" then suggestion.approve!
    when "decline" then suggestion.decline!
    end
    redirect_back fallback_location: suggestions_path, notice: "Suggestion #{params[:decision]}d."
  end

  private

  def agent_suggestions
    Suggestion.joins(:tour).where(tours: { agent_id: current_agent.id })
  end
end
