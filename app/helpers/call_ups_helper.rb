module CallUpsHelper
  def status_badge_class(status)
    case status.to_sym
    when :draft
      "bg-secondary"
    when :finalized
      "bg-primary"
    when :notified
      "bg-warning text-dark"
    when :completed
      "bg-success"
    else
      "bg-light text-dark"
    end
  end
end