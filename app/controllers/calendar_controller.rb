class CalendarController < ApplicationController
  def show
    @month = (params[:month] || Date.current.month).to_i
    @year = (params[:year] || Date.current.year).to_i
    first = Date.new(@year, @month, 1)
    last = first.end_of_month

    cells = Array.new(first.wday) + (first..last).to_a
    cells << nil until (cells.size % 7).zero?
    @cells = cells
    @first = first
    @prev_month = first.prev_month
    @next_month = first.next_month
    @tours_by_date = current_agent.tours.includes(:client).where(tour_date: first..last).group_by(&:tour_date)
  end
end
