class AddAdminAndHrRefToAttendances < ActiveRecord::Migration[5.2]
  def change
    add_reference :attendances, :admin, foreign_key: true
    add_reference :attendances, :hr, foreign_key: true
  end
end
