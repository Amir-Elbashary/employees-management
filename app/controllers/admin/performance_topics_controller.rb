class Admin::PerformanceTopicsController < Admin::BaseAdminController
  load_and_authorize_resource
  before_action :set_performances, only: :leaderboard

  def new; end

  def create
    if @performance_topic.save
      flash[:notice] = 'Performance Topic has been added.'
      redirect_to admin_performance_topics_path
    else
      render 'new'
    end
  end

  def edit; end

  def update
    if @performance_topic.update(performance_topic_params)
      flash[:notice] = 'Changes has been saved'
      redirect_to admin_performance_topics_path
    else
      render 'edit'
    end
  end

  def index; end

  def leaderboard; end

  def destroy
    return unless @performance_topic.destroy
    flash[:notice] = 'Performance Topic was deleted.'
    redirect_to admin_performance_topics_path
  end

  private

  def performance_topic_params
    params.require(:performance_topic).permit(:title)
  end

  def set_performances
    if params[:year] && params[:month]
      @performances = Performance.where(topic: @performance_topic.title, year: params[:year], month: params[:month]).order(score: :desc)
    end
  end
end
