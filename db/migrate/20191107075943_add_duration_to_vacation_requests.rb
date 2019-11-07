class AddDurationToVacationRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :vacation_requests, :duration, :integer, default: 0
  end
end
