Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :players
  resources :games do

    member do
      put :saveResult
    end
 

    collection do #collection porque no va a apuntar a un game especifico, sino a una collection
      get :indexOpenGames #este action lo voy a usar para mostrar los games disponibles
    end
  end
end
