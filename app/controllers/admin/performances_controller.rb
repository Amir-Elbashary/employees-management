class Admin::PerformancesController < Admin::BaseAdminController
  load_and_authorize_resource
  skip_load_resource
  before_action :set_performance, except: :index
  before_action :set_employee
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
    @performances = @employee.performances
  end

  def set_performance_topics
    @performance_topics = PerformanceTopic.all
  end
end
