class AddKindToVacationRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :vacation_requests, :kind, :integer, default: 0
    add_index :vacation_requests, :kind
  end
end
