class Admin::PerformancesController < Admin::BaseAdminController
  load_and_authorize_resource
  skip_load_resource
  before_action :set_performance, except: %i[index compare employee_performance]
  before_action :set_employee
  before_action :ensure_same_employee, only: :employee_performance
  before_action :set_performances
  before_action :set_performance_topics, except: %i[index destroy]

  def new; end

  def create
    if @performance.save
      flash[:notice] = 'Performance has been added.'
      redirect_to admin_employee_performances_path(@performance.employee)
    else
      render :new
    end
  end

  def edit; end

  def update
    if @performance.update(performance_params)
      flash[:notice] = 'Changes has been saved'
      redirect_to admin_employee_performances_path(@performance.employee)
    else
      render :edit
    end
  end

  def index; end

  def employee_performance; end

  def compare; end

  def destroy
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

  def set_performance
    @performance = if action_name == 'new'
                     Performance.new
                   elsif action_name == 'create'
                     Performance.new(performance_params)
                   else
                     Performance.find(params[:id])
                   end
  end

  def set_performances
    if params[:year_from]
      previous_date = Date.new(params[:year_from].to_i, params[:month_from].to_i)
      last_date = Date.new(params[:year_to].to_i, params[:month_to].to_i)
      flash[:notice] = 'Please compare past with future' if last_date < previous_date
      return redirect_to compare_admin_employee_performances_path(params[:employee_id]) if last_date < previous_date
    end

    if params[:topic]
      @previous_performance = @employee.performances.where(topic: params[:topic],
                                   year: params[:year_from],
                                   month: params[:month_from],
                                   employee_id: params[:employee_id]).first
      @last_performance = @employee.performances.where(topic: params[:topic],
                                   year: params[:year_to],
                                   month: params[:month_to],
                                   employee_id: params[:employee_id]).first
    else
      @performances = @employee.performances
    end
    @total_performances = PerformanceTopic.count * 5
  end

  def set_performance_topics
    @performance_topics = PerformanceTopic.all
  end

  def ensure_same_employee
    return unless current_employee
    redirect_to admin_path if @employee != current_employee
  end
end
