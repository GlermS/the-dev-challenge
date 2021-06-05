Rails.application.routes.draw do
  post 'purchases/post_file'
  get 'purchases/get_all_time'
  root to: 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
