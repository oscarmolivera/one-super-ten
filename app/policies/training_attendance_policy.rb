class TrainingAttendancePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope # Add your scope logic here if needed
    end
  end
end