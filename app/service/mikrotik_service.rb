require 'net/ssh'

class MikrotikService
  def initialize(host: '192.168.88.1', user: 'ramel', password: '123123123')
    @host = host
    @user = user
    @password = password
    @connection = establish_connection
  end

  def add_hotspot_user_profile(name:,  rate_limit: nil, shared_users: 1, idle_timeout: 'none')
    command = "/ip hotspot user profile add " \
              "name=#{Shellwords.escape(name)} " \
              "shared-users=#{shared_users} " \
              "idle-timeout=#{Shellwords.escape(idle_timeout)}"

    command += " rate-limit=#{Shellwords.escape(rate_limit)}" if rate_limit.present?
    
    execute_command(command)
  end

  def add_user(username:, profile: 'default', time_limit: '1d')
    command = build_user_command(username, profile, time_limit)
      
  end

  def fetch_router_data
    command = '/system resource print'
    response = execute_command(command)
    parsed_hash = response.lines.each_with_object({}) do |line, hash|
      data = line.split(':', 2).map(&:strip)
      hash[data[0]] = data[1] if data.size == 2
    end
  end

  private

  def establish_connection
    Net::SSH.start(@host, @user, password: @password, 
                  timeout: 10,
                  auth_methods: ['password'],
                  verbose: :error) # For debugging
  end

  def build_user_command(username, profile, time_limit)
    # Proper MikroTik CLI syntax with correct parameter format
    "/ip hotspot user add " \
    "name=#{username.shellescape} " \
    "profile=#{profile.shellescape} " \
    "limit-uptime=#{time_limit.shellescape}"
  end

  def execute_command(command)
    output = ''
    @connection.open_channel do |channel|
      channel.exec(command) do |ch, success|
        unless success
          raise "SSH command failed to start: #{command}"
        end

        channel.on_data do |_, data|
          output << data
        end

        channel.on_extended_data do |_, _, data|
          output << data
        end

        channel.on_request("exit-status") do |_, data|
          @exit_status = data.read_long
        end
      end
    end

    @connection.loop
    output
    
  end
end