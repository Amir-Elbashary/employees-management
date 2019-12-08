class AddRemainingCheckoutTimeToSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :add_remaining_checkout_time, :boolean, default: true
  end
end
