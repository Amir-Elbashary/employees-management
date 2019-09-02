module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.add_tags 'ActionCable', current_user.full_name, current_user.class.name
    end

    private

    def find_verified_user
      if verified_user = Admin.find_by(id: cookies.signed['admin.id']) ||
                         Hr.find_by(id: cookies.signed['manager.id']) ||
                         Employee.find_by(id: cookies.signed['employee.id'])
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
