Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :admins, controllers: {
    sessions: 'admins/sessions'
  }

  devise_for :hrs, controllers: {
    sessions: 'hrs/sessions'
  }

  devise_for :employees, controllers: {
    sessions: 'employees/sessions'
  }

  get '/ceo' => redirect('/admins/sign_in')
  get '/hr' => redirect('/hrs/sign_in')
  get '/' => redirect('/employees/sign_in')

  namespace :admin do
    get '/', to: 'admins#dashboard'

    get :profile, to: 'admins#edit'
    post :profile, to: 'admins#update'
    post :updates_tracker, to: 'admins#updates_tracker'
    post :change_password, to: 'admins#change_password'
    post :change_profile_pic, to: 'admins#change_profile_pic'


    resources :settings, only: %i[index update] do
      collection do
        get :dashboard

        post :refresh_permissions
      end
    end

    resources :updates, except: :show do
      collection do
        post :reset_ip
      end
    end

    resources :notifications
    resources :roles
    resources :hrs
    resources :sections
    resources :holidays
    resources :rooms
    resources :room_messages
    resources :recruitments
    resources :timelines

    resources :attendances do
      collection do
        get :reports

        post :append
        post :checkin
        post :checkout
        post :checkin_reminder
        post :checkout_reminder
      end

      member do
        post :grant
        post :revoke
      end
    end

    resources :vacation_requests do
      collection do
        get :pending
      end

      member do
        get :escalation
        patch :escalate
        post :approve
        post :decline
        post :confirm
        post :refuse
      end
    end

    resources :employees do
      member do
        post :resend_mail
        post :toggle_level
      end
    end

  end
end
