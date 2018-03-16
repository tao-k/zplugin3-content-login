class Login::Piece::User < Cms::Piece

  default_scope { where(model: 'Login::User') }


  def content
    Login::Content::User.find(super.id)
  end

  def login_label
    setting_value(:login_label).presence || "ログイン"
  end

  def logout_label
    setting_value(:logout_label).presence || "ログアウト"
  end

end
