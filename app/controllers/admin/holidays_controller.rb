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
end
