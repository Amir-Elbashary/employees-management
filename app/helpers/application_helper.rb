module ApplicationHelper
  def bootstrap_class_for flash_type
    case flash_type
      when 'success'
        "alert-success" # Green
      when 'danger'
        "alert-danger" # Red
      when 'alert'
        "alert-warning" # Yellow
      when 'notice'
        "alert-info" # Blue
      else
        puts flash_type
    end
  end

	def toast_bootstrap_class_for flash_type
    case flash_type
      when 'success'
        "success" # Green
      when 'danger'
        "error" # Red
      when 'warning'
        "warning" # Yellow
      when 'notice'
        "info" # Blue
      else
        puts flash_type
    end
  end

  def formatted_date(date)
    date.strftime('%d-%m-%Y') unless date.nil?
  end

  def formatted_time(time)
    time.strftime('%I:%M %p') unless time.nil?
  end

  def tree_formatting(spaces, dashes)
    tree_spaces = '|' + ('&nbsp;' * 6)
    tree_dashes = '|' + ('-' * 4)

    format = if spaces == 0
               tree_dashes * dashes
             elsif dashes == 0
               tree_spaces * spaces
            else
              (tree_spaces * spaces) + (tree_dashes * dashes)
            end

    format.html_safe
  end

  def he_she(person)
    return 'he' if person.male?
    'she' if person.female?
  end

  def his_her(person)
    return 'his' if person.male?
    'her' if person.female?
  end

  def him_her(person)
    return 'him' if person.male?
    'her' if person.female?
  end

  def welcome_messages
    ['Show us what you\'ve got today!',
     'Your limitation... it’s only your imagination.',
     'Dream it. Wish it. Do it.',
     'Success doesn’t just find you. You have to go out and get it.',
     'The harder you work for something, the greater you’ll feel when you achieve it.',
     'Don’t stop when you’re tired. Stop when you’re done.',
     'Wake up with determination. Go to bed with satisfaction.',
     'Do something today that your future self will thank you for.',
     'Don’t wait for opportunity. Create it.',
     'Dream it. Believe it. Build it.']
  end
end
