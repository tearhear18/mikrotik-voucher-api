class RoutersController < ApplicationController
  before_action :set_router, only: [:show, :fetch_router_data]

  def index
    @routers = current_user.routers.includes(:stations, :hotspot_profiles)
  end

  def show
    @profiles = @router.hotspot_profiles
    @stations = @router.stations
    @connection_status = @router.connection_status
    @device_info = @router.device_info
  end

  def fetch_router_data
    if @router.fetch_data
      redirect_to @router, notice: 'Router data fetched successfully.'
    else
      redirect_to @router, alert: 'Failed to fetch router data. Please check the connection settings.'
    end
  end

  def new
    @router = current_user.routers.build
  end

  def create
    @router = current_user.routers.build(router_params)
    
    if @router.save
      redirect_to @router, notice: 'Router was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @router = current_user.routers.find(params[:id])
  end

  def update
    @router = current_user.routers.find(params[:id])
    
    if @router.update(router_params)
      redirect_to @router, notice: 'Router was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def test_connection
    @router = current_user.routers.find(params[:id])
    
    if @router.test_connection
      redirect_to @router, notice: 'Connection test successful.'
    else
      redirect_to @router, alert: 'Connection test failed. Please check your settings.'
    end
  end

  private

  def set_router
    @router = current_user.routers.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to routers_path, alert: 'Router not found.'
  end

  def router_params
    params.require(:router).permit(:name, :host_name, :username, :password)
  end
end
