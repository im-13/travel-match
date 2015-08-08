Rails.application.routes.draw do

  resources :blogs 
  resources :comments,     only: [:new, :create, :destroy]

  root 'static_pages#home'

  get 'password_resets/new'
  get 'password_resets/edit'
  get   'home'      => 'static_pages#home'
  get   'help'      => 'static_pages#help'
  get   'about'     => 'static_pages#about'
  get   'contact'   => 'static_pages#contact'
  get   'profile'   => 'static_pages#profile'
  get   'signup'    => 'users#new'
  get   'myblog'    => 'users#show_my_blog'
  get   'index'     => 'users#index'
  get   'messages'  => 'users#show_messages'
  get   'login'     => 'sessions#new'
  post  'login'     => 'sessions#create'
  get   'travelblog'      => 'blogs#index'
  get   'blog'      => 'blogs#index'
  get   'show'      => 'blogs#show'
  get   'mymatches' => 'matches#new'
  post  'mymatches' => 'matches#create'
  get   'comments' => 'comments#new'
  post  'comments' => 'comments#create'
  delete 'comments' => 'comments#destroy'
  get   'default'   => 'matches#default'
  get   'yourviews' => 'viewed_users#index'
  get   'otherviews'=> 'visitors#index'
  delete 'logout'   => 'sessions#destroy'
  post  'unfollow'  => 'follows#destroy'
  post  'follow'    => 'follows#create'
  get   'favorites'  => 'follows#index'
  get   'newtrip'   => 'trips#new'
  post  'newtrip'   => 'trips#create'
  get   'alltrips'  => 'trips#index'
  get   'findtrip'  => 'trips#find'
  post  'findtrip'  => 'trips#find'
  post  'traveled'  => 'users#traveled'
  post  'want'      => 'users#want'
  #post   'conversations' => 'conversations#create'
  #get    'conversations' => 'conversations#show'

  resources :users
  resources :countries
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :trips
  resources :carrierwave_images
  resources :documents
  resources :conversations do
  resources :messages
  end

  #resources :follows, only: [:create, :destroy]
  #resources :match

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
