module CupsHelper
  def display_cup_logo(cup, options = {})
    return image_tag('placeholder-1.png', options.merge(alt: 'Sin logo')) unless cup.logo.attached?

    if cup.logo.content_type == 'image/svg+xml'
      image_tag cup.logo, options.merge(alt: "#{cup.name} logo", style: 'width: 100%; height: 200px; object-fit: contain;')
    else
      image_tag cup.logo.variant(resize_to_limit: [800, 400]), options.merge(alt: "#{cup.name} logo")
    end
  end
end