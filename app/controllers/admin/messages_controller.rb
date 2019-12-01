class Admin::MessagesController < Admin::BaseAdminController
  load_and_authorize_resource
  skip_load_resource only: :index
  before_action :set_messages
  before_action :require_same_user, only: :show
  before_action :set_recipients, only: :create

  def new; end

  def create
    sent_messages_count = current_active_user.sent_messages.count

    send_messages

    if current_active_user.sent_messages.count > sent_messages_count
      flash[:notice] = 'Messages sent, Please check your sent messages to make sure they are sent'
    else
      flash[:danger] = 'Nothing sent, All emails entered are invalid'
    end

    redirect_to admin_messages_path
  end

  def index; end

  def show
    @message.read! if @message.recipient == current_active_user
  end

  def mark_all_as_read
    @messages.each(&:read!)
    redirect_to request.referer
  end

  private

  def message_params
    params.require(:message).permit(:subject, :content)
  end

  def set_recipients
    @recipients = params[:message][:recipient].split(',')
  end

  def set_messages
    @messages = current_active_user.received_messages
    @sent_messages = current_active_user.sent_messages
  end

  def create_message(resource)
    Message.create(sender: current_active_user,
                   subject: params[:message][:subject],
                   content: params[:message][:content],
                   files: params[:message][:files],
                   recipient: resource)
  end

  def send_messages
    @recipients.map do |recipient|
      recipient_email = recipient.strip.downcase

      if recipient_email == 'all'
        create_messages([Admin, Hr, Employee])
      else
        find_resource_and_create_message(recipient_email)
      end
    end
  end

  def create_messages(models)
    models.map do |model|
      model.find_each do |resource|
        next if resource.email == current_active_user.email
        create_message(resource)
      end
    end
  end

  def find_resource_and_create_message(recipient_email)
    admin = Admin.where(email: recipient_email).first
    hr = Hr.where(email: recipient_email).first
    employee = Employee.where(email: recipient_email).first

    create_message(admin) if admin
    create_message(hr) if hr
    create_message(employee) if employee
  end

  def require_same_user
    return if @message.sender == current_active_user || @message.recipient == current_active_user
    redirect_to admin_path
  end
end
