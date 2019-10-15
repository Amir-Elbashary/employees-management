class Ability
  include CanCan::Ability
  AUTHORIZABLE_MODELS = [Employee, VacationRequest, Attendance, Recruitment,
                         Timeline, Holiday, Notification]
  END_USERS_MODELS = [Employee]
  END_USERS_AUTHORIZED_MODELS = [VacationRequest, RoomMessage]

  def initialize(user)
    case user
    when Admin
      # Admin can manage everything
      can :manage, :all
    when Hr
      # H.R can manage anything he has access on.
      user.roles.each do |role|
        role.permissions.each do |permission|
          model = permission.target_model_name.constantize
          can permission.action.to_sym, model
        end
      end

      can :checkin_reminder, Attendance
      can :checkout_reminder, Attendance
      can :toggle_read_status, Notification
      can :toggle_all_read_status, Notification
    when Employee
      # Employees have access to specific models only
      authorize_models(END_USERS_MODELS, END_USERS_AUTHORIZED_MODELS)
      can :read, Notification
      can :toggle_read_status, Notification
      can :toggle_all_read_status, Notification
      can :manage, Update if ENV['DEVELOPERS'].include?(user.email)
      can :updates_tracker, Admin
      cannot :manage, Employee
      can :profile, Employee
      can :update_profile, Employee
      can :manage, Timeline
      can :change_password, Admin
      can :change_profile_pic, Admin
      can :read, [Room, Attendance]
      can :create, Attendance
      can :checkin, Attendance
      can :checkout, Attendance
      can :checkin_reminder, Attendance
      can :checkout_reminder, Attendance
    end
  end

  def authorize_models(user_models, target_models)
    user_models.concat(target_models).each do |model|
      can :manage, model
    end
  end
end
