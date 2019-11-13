class RemoveHrIdFromVacationRequests < ActiveRecord::Migration[5.2]
  def change
    remove_column :vacation_requests, :hr_id
  end
end
