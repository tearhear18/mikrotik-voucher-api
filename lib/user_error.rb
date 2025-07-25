class UserError < StandardError
  attr_reader :path

  def initialize(message, path)
    @path = path
    # call default standard initializer
    super(message)
  end
end