RujiaSession::Engine.routes.draw do
  devise_for :users

  scope '/user' do

    get 'login' => 'sessions#login'
    post 'login_post' => 'sessions#login_post', :as => 'login_post'

    delete 'logout' => 'sessions#logout'
  end
end
