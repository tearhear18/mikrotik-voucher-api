class Router < ApplicationRecord
  has_many :stations, dependent: :destroy
  has_many :hotspot_profiles, dependent: :destroy
  belongs_to :user

  BANDWIDTH = {
    "1 MBPS"=>"1M/1M",
    "2 MBPS"=>"2M/2M",
    "3 MBPS"=>"3M/3M",
    "4 MBPS"=>"4M/4M",
    "5 MBPS"=>"5M/5M",
    "6 MBPS"=>"6M/6M",
    "7 MBPS"=>"7M/7M",
    "8 MBPS"=>"8M/8M",
    "9 MBPS"=>"9M/9M",
    "10 MBPS"=>"10M/10M",
    "11 MBPS"=>"11M/11M",
    "12 MBPS"=>"12M/12M",
    "13 MBPS"=>"13M/13M",
    "14 MBPS"=>"14M/14M",
    "15 MBPS"=>"15M/15M",
    "16 MBPS"=>"16M/16M",
    "17 MBPS"=>"17M/17M",
    "18 MBPS"=>"18M/18M",
    "19 MBPS"=>"19M/19M",
    "20 MBPS"=>"20M/20M"
  }

  def connect
    MikrotikService.new(
      host: host_name,
      user: username,
      password: password
    ) 
  end
end
