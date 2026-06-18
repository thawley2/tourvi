class DashboardController < ApplicationController
  def show
    @week_offset = params[:week].to_i
    @week_start = Date.current.beginning_of_week(:sunday) + @week_offset.weeks
    @week_days = (0..6).map { |i| @week_start + i }

    tours = current_agent.tours.includes(:client, :properties)
    @tours_by_date = tours.where(tour_date: @week_start..@week_days.last).group_by(&:tour_date)
    @tours = tours.order(Arel.sql("tour_date DESC NULLS LAST"))
  end
end
