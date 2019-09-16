class AddWorkFromHomeDaysInSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :work_from_home, :integer, default: 0
  end
end
