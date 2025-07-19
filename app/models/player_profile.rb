class PlayerProfile < ApplicationRecord
  belongs_to :player

  enum :status, { active: 0, suspended: 1, injured: 2 }

  # Ensure social_links returns a hash
  def social_links
    super || {}
  end

  # Virtual attribute for Facebook
  def social_links_facebook
    social_links["facebook"]
  end

  def social_links_facebook=(value)
    self.social_links = (social_links || {}).merge("facebook" => value.presence).compact
  end

  # Virtual attribute for Instagram
  def social_links_instagram
    social_links["instagram"]
  end

  def social_links_instagram=(value)
    self.social_links = (social_links || {}).merge("instagram" => value.presence).compact
  end

  # Virtual attribute for TikTok
  def social_links_tiktok
    social_links["tiktok"]
  end

  def social_links_tiktok=(value)
    self.social_links = (social_links || {}).merge("tiktok" => value.presence).compact
  end
end