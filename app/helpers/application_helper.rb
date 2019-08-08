module ApplicationHelper
  def bootstrap_class_for flash_type
    case flash_type
      when 'success'
        "alert-success" # Green
      when 'error'
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
    date.strftime('%d/%m/%Y') unless date.nil?
  end
end
