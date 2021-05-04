module ApplicationHelper
  def avatar_for(name)
    url = "https://avatars.dicebear.com/v2/initials/#{name.parameterize}.svg"
    image_tag url, alt: name, class: 'is-rounded'
  end
end
