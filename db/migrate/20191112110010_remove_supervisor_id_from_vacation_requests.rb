class RemoveSupervisorIdFromVacationRequests < ActiveRecord::Migration[5.2]
  def change
    remove_column :vacation_requests, :supervisor_id
  end
end
