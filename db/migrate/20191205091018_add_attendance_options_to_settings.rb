class AddAttendanceOptionsToSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :send_attendance_summary, :boolean, default: true
    add_column :settings, :send_checkout_reminder, :boolean, default: true
    add_column :settings, :checkout_reminder_minutes, :integer, default: 5
  end
end
