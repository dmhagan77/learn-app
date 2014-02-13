HagaLearningApp::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  resources :words
  root 'words#index'

  match '/' , to: "words#index" , via: "post"
end
