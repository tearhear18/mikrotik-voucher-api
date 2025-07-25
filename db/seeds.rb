# Create a default user for testing
user = User.find_or_create_by(username: 'admin') do |u|
  u.password = 'password'
  u.password_confirmation = 'password'
end

puts "Created user: #{user.username}"

# Create a default router
router = user.routers.find_or_create_by(name: 'Main Router') do |r|
  r.host_name = '192.168.1.1'
  r.username = 'admin'
  r.password = 'admin'
  r.port = 8728
end

puts "Created router: #{router.name}"

# Create stations under the router
stations_data = [
  { name: 'Kap Station', prefix: 'RC', commission_rate: 30.0 },
  { name: 'LM Station', prefix: 'LM', commission_rate: 25.0 },
  { name: 'Main Station', prefix: 'AA', commission_rate: 35.0 },
  { name: 'Womens Station', prefix: 'WN', commission_rate: 30.0 },
  { name: 'Odol Station', prefix: 'AB', commission_rate: 28.0 }
]

stations_data.each do |station_data|
  station = router.stations.find_or_create_by(prefix: station_data[:prefix]) do |s|
    s.name = station_data[:name]
    s.commission_rate = station_data[:commission_rate]
  end
  puts "Created station: #{station.name} (#{station.prefix})"
end

# Create some hotspot profiles
hotspot_profiles_data = [
  { name: '1 Hour', rate_limit: '1M/1M' },
  { name: '3 Hours', rate_limit: '2M/2M' },
  { name: '5 Hours', rate_limit: '3M/3M' },
  { name: 'Unlimited', rate_limit: '5M/5M' }
]

hotspot_profiles_data.each do |profile_data|
  profile = router.hotspot_profiles.find_or_create_by(name: profile_data[:name]) do |p|
    p.rate_limit = profile_data[:rate_limit]
  end
  puts "Created hotspot profile: #{profile.name}"
end

puts "Seed data created successfully!"
puts "Login with username: admin, password: password"
