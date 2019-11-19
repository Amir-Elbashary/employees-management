class CreatePerformanceTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :performance_topics do |t|
      t.string :title
      t.timestamps
    end
  end
end
