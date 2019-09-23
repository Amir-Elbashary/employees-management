class AddTimeToVacationRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :vacation_requests, :starts_at, :time
    add_column :vacation_requests, :ends_at, :time
  end
end
