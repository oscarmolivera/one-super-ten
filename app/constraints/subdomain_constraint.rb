class SubdomainConstraint
  def self.matches?(request)
    request.subdomain.present? && request.subdomain != 'www' && request.subdomain != 'admin'
  end
end