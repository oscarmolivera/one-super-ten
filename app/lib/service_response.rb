class ServiceResponse
  attr_reader :data, :error

  def initialize(success:, data: {}, error: nil)
    @success = success
    @data = data
    @error = error
  end

  def self.success(data = {})
    new(success: true, data: data)
  end

  def self.error(data = {}, error: nil)
    new(success: false, data: data, error: error)
  end

  def success?
    @success
  end
end