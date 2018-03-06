Cms::Lib::Modules::ModuleSet.draw :login, 'ログイン情報：プラグイン', 999 do |mod|
#  ## contents
  mod.content :users, 'ログイン情報：プラグイン'

#  ## directories
  mod.directory :users, 'ログイン：プラグイン'

  ## pieces
  mod.piece :users, 'ログイン：プラグイン'
end