Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :players, except: [:update, :destroy, :new, :edit] do
    member do
      get :login
    end
  end

  
  resources :games, except: [:update, :destroy, :new, :edit] do

    member do
      put :join
      put :save_result
    end
 

    collection do #collection porque no va a apuntar a un game especifico, sino a una collection
     # get :indexOpenGames No lo uso porque es mejor usar el index con parámetros de búsqueda. No lo borro para no olvidarme de este concepto.
    end
  end
end
