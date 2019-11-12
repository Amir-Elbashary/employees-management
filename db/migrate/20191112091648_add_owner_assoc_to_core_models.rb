class AddOwnerAssocToCoreModels < ActiveRecord::Migration[5.2]
  def change
    add_reference :attendances, :attender, polymorphic: true
    add_reference :comments, :commenter, polymorphic: true
    add_reference :timelines, :publisher, polymorphic: true
    add_reference :vacation_requests, :requester, polymorphic: true
  end
end
