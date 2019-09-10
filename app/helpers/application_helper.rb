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
end
