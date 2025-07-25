class RoutersController < ApplicationController
  def index
    @routers = current_user.routers
  end

  def show
    @router = current_user.routers.find(params[:id])
    @profiles = @router.hotspot_profiles
    @stations = @router.stations
  end

  def fetch_router_data
    @router = current_user.routers.find(params[:id])
    @router.raw_data[:device_info] = @router.connect.fetch_router_data
    @router.save!
    redirect_to @router, notice: 'Router data fetched successfully.' if @router.fetch_data
  rescue StandardError => e
    redirect_to @router, alert: "Failed to fetch router data: #{e.message}"
  end

  def create 
    @router = current_user.routers.new(router_params)
    if @router.save
      redirect_to @router, notice: 'Router was successfully created.'
    else
      render :new
    end
  end

  private 

  def router_params
    params.require(:router).permit(:name, :host_name, :username, :password)
  end
end
