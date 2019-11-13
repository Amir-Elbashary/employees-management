class Admin::HolidaysController < Admin::BaseAdminController
  load_and_authorize_resource

  def create
    @holiday.ends_on = @holiday.starts_on + @holiday.duration.days
    if @holiday.save
      flash[:notice] = 'Holiday has been added and announced.'
      redirect_to admin_holidays_path
    else
      render 'new'
    end

    create_timeline_post(@holiday.content) if params[:holiday][:announce]
    send_emails if params[:holiday][:announce]
  end

  def index; end

  def destroy
    return unless @holiday.destroy
    flash[:notice] = 'Holiday was canceled.'
    redirect_to admin_holidays_path
  end

  private

  def holiday_params
    params.require(:holiday).permit(:name, :content, :year, :month,
                                    :duration, :starts_on)
  end

  def create_timeline_post(content)
    Timeline.create(publisher: current_active_user,
                    images: [],
                    kind: 'news',
                    creation: 'manual',
                    content: content)
  end

  def send_emails
    Holiday::MailNotifierWorker.perform_async(@holiday.id)
  end
end
