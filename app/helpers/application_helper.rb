module ApplicationHelper
  include Pagy::Frontend

  def avatar_for(name)
    url = "https://avatars.dicebear.com/v2/initials/#{name.parameterize}.svg"
    image_tag url, alt: name, class: 'is-rounded'
  end

  def date_in_full_words(date_object)
    date_object.strftime("%A, %d %b %Y")
  end

  def date_in_full_words_with_time(date_object)
    date_object.strftime("%A, %d %b %Y %I:%M%p")
  end

  def available_plans
    Plans.available_plans
  end

  def available_payment_methods
    Payments.available_payment_methods
  end
end
