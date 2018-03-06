mod = "login"

Zplugin3::Content::Login::Engine.routes.draw do
  root "#{mod}/contents#index"
end
