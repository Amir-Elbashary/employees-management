Rails.application.routes.draw do

  devise_for :admins, controllers: {
    sessions: 'admins/sessions'
  }

  devise_for :hrs, controllers: {
    sessions: 'hrs/sessions'
  }

  devise_for :employees, controllers: {
    sessions: 'employees/sessions'
  }

  namespace :admin do
    get '/', to: 'admins#dashboard'

    get :profile, to: 'admins#edit'
    post :profile, to: 'admins#update'

    resources :settings, only: :index do
      collection do
        get :dashboard

        post :refresh_permissions
      end
    end

    resources :roles
    resources :hrs
    resources :employees
  end
end
