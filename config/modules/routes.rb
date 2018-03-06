mod = "login"
ZomekiCMS::Application.routes.draw do
  ## admin
  scope "#{ZomekiCMS::ADMIN_URL_PREFIX}/#{mod}/c:concept", :module => mod, :as => mod do
    resources :content_base,
      :controller => 'admin/content/base'

    resources :content_settings, :only => [:index, :show, :edit, :update],
      :controller => 'admin/content/settings',
      :path       => ':content/content_settings'

  #  ## contents
    resources(:users,
      :controller => 'admin/users',
      :path       => ':content/users')

    ## nodes
    resources :node_users,
      :controller => 'admin/node/users',
      :path       => ':parent/node_users'

    ## pieces
    resources :piece_users,
      :controller => 'admin/piece/users'
  end


  ## public
  scope "_public/#{mod}", :module => mod, :as => '' do
    get  'node_users/login(/index.:format)' => 'public/node/users#login'
    post 'node_users/login(/index.:format)' => 'public/node/users#login'
    get  'node_users/logout(/index.:format)' => 'public/node/users#logout'
  end
end
