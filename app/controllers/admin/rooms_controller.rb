class Admin::RoomsController < Admin::BaseAdminController
  load_and_authorize_resource

  def show; end
end
