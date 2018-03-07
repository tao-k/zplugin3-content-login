Cms::Lib::Modules::ModuleSet.draw :login, 'ログイン情報', 999 do |mod|
#  ## contents
  mod.content :users, 'ログイン情報'

#  ## directories
  mod.directory :users, 'ログイン'

  ## pieces
  mod.piece :users, 'ログイン'
end