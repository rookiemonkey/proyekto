module ApplicationHelper
  include Pagy::Frontend

  def avatar_for(name)
    url = "https://avatars.dicebear.com/v2/initials/#{name.parameterize}.svg"
    image_tag url, alt: name, class: 'is-rounded'
  end

  def available_plans
    Plans.available_plans
  end

  def available_payment_methods
    Payments.available_payment_methods
  end
end
