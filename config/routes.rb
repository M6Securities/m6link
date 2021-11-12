Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'site/home#index'

  namespace :site do
    match '/create_shortlink' => 'home#create_shortlink', via: %i[post put patch]

    resources :shortlink_details, only: :show
    resources :ranking, only: :index
  end

  # this must be the very last
  get '/:shortcut' => 'shortcut#link', as: :shortcut
end
