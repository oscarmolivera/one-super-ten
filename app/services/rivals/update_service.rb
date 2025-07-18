module Rivals
  class UpdateService
    def initialize(rival:, params:)
      @rival = rival
      @params = params
    end

    def call
      if @rival.update(@params)
        ServiceResponse.success(rival: @rival)
      else
        ServiceResponse.error(rival: @rival)
      end
    end
  end
end