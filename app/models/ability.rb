class Ability
  include CanCan::Ability
  AUTHORIZABLE_MODELS = [Employee, VacationRequest, Attendance, Recruitment,
                         Timeline, Comment, Holiday, Notification, Message,
                         PerformanceTopic, Performance]
  END_USERS_MODELS = [Employee]
  END_USERS_AUTHORIZED_MODELS = [VacationRequest, Message, Timeline, Comment,
                                 React, RoomMessage]

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

      hr_abilities
    when Employee
      # Employees have access to specific models only
      authorize_models(END_USERS_MODELS, END_USERS_AUTHORIZED_MODELS)
      employee_abilities(user)
    else
      can %i[remote_checkout postpone_checkout_reminder], Attendance
    end
  end

  private

  def authorize_models(user_models, target_models)
    user_models.concat(target_models).each do |model|
      can :manage, model
    end
  end

  def hr_abilities
    can :leaderboard, PerformanceTopic
    can :manage, Performance
    can :birthdays, Employee
    can :compare, Employee
    can :manage, React
    can :checkin_reminder, Attendance
    can :checkout_reminder, Attendance
    can :toggle_read_status, Notification
    can :toggle_all_read_status, Notification
    can :mark_all_as_read, Message
  end

  def employee_abilities(employee)
    cannot :manage, Employee
    can %i[profile update_profile birthdays], Employee
    can %i[change_password change_profile_pic updates_tracker], Admin
    can %i[read create checkin checkout remote_checkout postpone_checkout_reminder checkin_reminder checkout_reminder], Attendance
    can :employee_performance, Performance
    can :read, Room
    can %i[read toggle_read_status toggle_all_read_status], Notification
    can :manage, Update if ENV['DEVELOPERS'].include?(employee.email)
  end
end
