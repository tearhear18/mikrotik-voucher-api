require 'net/ssh'
require 'shellwords'

class MikrotikService
  class ConnectionError < StandardError; end
  class CommandError < StandardError; end

  def initialize(host:, user:, password:)
    @host = host
    @user = user
    @password = password
    @connection = nil
  end

  def add_hotspot_user_profile(name:, rate_limit: nil, shared_users: 1, idle_timeout: 'none')
    command = "/ip hotspot user profile add " \
              "name=#{Shellwords.escape(name)} " \
              "shared-users=#{shared_users} " \
              "idle-timeout=#{Shellwords.escape(idle_timeout)}"

    command += " rate-limit=#{Shellwords.escape(rate_limit)}" if rate_limit.present?
    
    execute_command(command)
  end

  def add_user(username:, profile: 'default', time_limit: '1d')
    command = build_user_command(username, profile, time_limit)
    execute_command(command)
  end

  def fetch_router_data
    command = '/system resource print'
    response = execute_command(command)
    
    parse_router_response(response)
  end

  def list_hotspot_users
    command = '/ip hotspot user print'
    execute_command(command)
  end

  def remove_user(username:)
    command = "/ip hotspot user remove [find name=#{Shellwords.escape(username)}]"
    execute_command(command)
  end

  def disconnect
    @connection&.close
    @connection = nil
  end

  private

  def connection
    @connection ||= establish_connection
  end

  def establish_connection
    Net::SSH.start(@host, @user, 
                   password: @password, 
                   timeout: 10,
                   auth_methods: ['password'],
                   verbose: :error)
  rescue Net::SSH::Exception => e
    raise ConnectionError, "Failed to connect to MikroTik router: #{e.message}"
  end

  def build_user_command(username, profile, time_limit)
    "/ip hotspot user add " \
    "name=#{Shellwords.escape(username)} " \
    "profile=#{Shellwords.escape(profile)} " \
    "limit-uptime=#{Shellwords.escape(time_limit)}"
  end

  def execute_command(command)
    output = ''
    exit_status = nil

    connection.open_channel do |channel|
      channel.exec(command) do |ch, success|
        raise CommandError, "SSH command failed to start: #{command}" unless success

        channel.on_data do |_, data|
          output << data
        end

        channel.on_extended_data do |_, _, data|
          output << data
        end

        channel.on_request("exit-status") do |_, data|
          exit_status = data.read_long
        end
      end
    end

    connection.loop

    if exit_status && exit_status != 0
      raise CommandError, "Command failed with exit status #{exit_status}: #{output}"
    end

    output.strip
  end

  def parse_router_response(response)
    response.lines.each_with_object({}) do |line, hash|
      data = line.split(':', 2).map(&:strip)
      hash[data[0]] = data[1] if data.size == 2
    end
  end
end