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
    if current_admin
      Timeline.create(admin: current_admin,
                      images: [],
                      kind: 'news',
                      creation: 'manual',
                      content: content)
    elsif current_hr
      Timeline.create(hr: current_hr,
                      images: [],
                      kind: 'news',
                      creation: 'manual',
                      content: content)
    end
  end
end
