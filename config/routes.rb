mod = "login"

Zplugin3::Content::Login::Engine.routes.draw do
  root "#{mod}/contents#index"
  scope "/", :module => mod, :as => mod do
    resources :contents do
      collection do
        get :install
      end
    end
  end
end
