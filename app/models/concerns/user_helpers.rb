module UserHelpers
  extend ActiveSupport::Concern

  def full_name
    first_name + ' ' + last_name
  end

  def formal_name
    return full_name if middle_name.nil?
    first_name + ' ' + middle_name + ' ' + last_name
  end

  def profile_pic
    avatar ? avatar : photo
  end
end
