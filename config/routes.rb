Rails.application.routes.draw do
  root 'login#show'
  resources :actions
  resources :groups,:only => [:index,:create]
  resources :notifications,:only => [:destroy]
  resource :login, :only => [:show], :controller => :login

  devise_for :users, :controllers => {
    :registrations => "users/registrations",
    :omniauth_callbacks => "users/omniauth_callbacks",
    :passwords => 'users/passwords',
    :sessions => 'users/sessions'
  }

  post 'actions/:action_id/users/:user_id/add_great' => 'greats#add_great'
  post 'actions/:action_id/users/:user_id/comments/:comment/add_comment' => 'comments#add_comment'
  post 'change_group' => 'groups#change_group'
  get 'gamification/:group_id' => 'groups#activate_gamification'
  get 'greats/:action_id' => 'greats#index'
  get 'mypage' => 'actions#me'
  get 'update_users' => 'users#update_users'
  get 'group_id/:group_id/password/:password' => 'actions#index'
  get 'group_show/:group_id' => 'actions#group_show'
  get 'send_mail' => 'mail#send_mail'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
