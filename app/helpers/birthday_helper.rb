module BirthdayHelper
  def birthdate_priority(birthdate)
    days_left = (birthdate - Time.zone.today).to_i

    if days_left.between?(2, 3)
      'warning'
    elsif days_left.between?(1, 2)
      'danger'
    elsif days_left.between?(0, 1)
      'success'
    else
      'primary'
    end
  end

  def upcoming_birthdays
    coming_soon = 0

    Employee.upcoming_birthdays.map do |birthday_obj|
      days_left = (birthday_obj[:birthdate] - Time.zone.today).to_i
      next if days_left.negative?
      coming_soon += 1 if days_left <= 3
    end

    return coming_soon if coming_soon.positive?
    nil
  end
end
