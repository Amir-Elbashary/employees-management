class Admin::SectionsController < Admin::BaseAdminController
  load_and_authorize_resource
  before_action :build_sub_sections, only: %i[new edit]

  def new; end

  def index
    @sections = @sections.roots.order(name: 'asc')
  end

  def show; end

  def edit; end

  def create
    if @section.save
      flash[:notice] = 'Section has been saved.'
      redirect_to admin_sections_path
    else
      render 'new'
    end
  end

  def update
    if @section.update(section_params)
      flash[:notice] = 'Section has been updated.'
      redirect_to admin_sections_path
    else
      render 'edit'
    end
  end

  def destroy
    employees = []

    Employee.all.each do |employee|
      employees << employee.full_name if employee.section.ancestors.include?(@section)
    end

    if employees.empty?
      @section.destroy
      flash[:notice] = 'Section was removed.'
    else
      flash[:danger] = "You can't delete section while it has employees assigned to it
                       , move them first, employees are (#{employees.join(', ')})"
    end

    redirect_to admin_sections_path
  end

  private

  def section_params
    params.require(:section).permit(:name, :parent_id, sub_sections_attributes: %i[id name _destroy])
  end

  def build_sub_sections
    @section.sub_sections.build
  end
end
