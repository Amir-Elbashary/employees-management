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

    resources :notifications do
      collection do
        post :toggle_all_read_status
      end

      member do
        post :toggle_read_status
      end
    end

    resources :messages, except: %i[edit update] do
      collection do
        post :mark_all_as_read
      end
    end

    resources :roles
    resources :hrs
    resources :sections
    resources :holidays
    resources :rooms
    resources :room_messages
    resources :recruitments
    resources :performance_topics do
      member do
        get :leaderboard
      end
    end

    resources :timelines do
      resources :reacts, only: %i[index] do
        collection do
          post :toggle
        end
      end
      resources :comments
    end

    resources :attendances do
      collection do
        get :remote_checkout
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
      resources :performances do
        collection do
          get :employee_performance
          get :compare
        end
      end

      member do
        get :profile
        patch :update_profile
        post :resend_mail
        post :toggle_level
        post :announce_birthday
      end

      collection do
        get :birthdays
      end
    end
  end
end
