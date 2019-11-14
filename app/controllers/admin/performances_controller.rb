class Admin::PerformancesController < Admin::BaseAdminController
  load_and_authorize_resource
  skip_load_resource
  before_action :set_employee
  before_action :set_performances

  def new
    @performance = Performance.new
    @performance_topics = PerformanceTopic.all
  end

  def create
    @performance_topics = PerformanceTopic.all
    @performance = Performance.new(performance_params)
    if @performance.save
      flash[:notice] = 'Performance has been added.'
      redirect_to admin_employee_performances_path(@performance.employee)
    else
      render :new
    end
  end

  def edit
    @performance = Performance.find(params[:id])
    @performance_topics = PerformanceTopic.all
  end

  def update
    @performance_topics = PerformanceTopic.all
    @performance = Performance.find(params[:id])
    if @performance.update(performance_params)
      flash[:notice] = 'Changes has been saved'
      redirect_to admin_employee_performances_path(@performance.employee)
    else
      render :edit
    end
  end

  def index; end

  def destroy
    @performance = Performance.find(params[:id])
    return unless @performance.destroy
    flash[:notice] = 'Performance was deleted.'
    redirect_to admin_employee_performances_path(@performance.employee)
  end

  private

  def performance_params
    params.require(:performance).permit(:employee_id, :year, :month, :topic,
                                        :score, :comment, :hr_comment)
  end

  def set_employee
    @employee = Employee.find(params[:employee_id])
  end

  def set_performances
    @performances = @employee.performances
  end
end
