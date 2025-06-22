class StationsController < ApplicationController
  def index
    @stations = Station.all    
    @event_counts = Event
      .where(mode: "login", created_at: 24.hours.ago..Time.current)
      .group_by_hour(
        :created_at,
        format: "%Y-%m-%d %H:%M",
        series: false,
        time_zone: "Asia/Manila"
      )
      .count
  end

  def show
    @station = Station.find(params[:id])
  end
end
