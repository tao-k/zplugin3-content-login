class Login::Admin::Piece::UsersController < Cms::Admin::Piece::BaseController

  def base_params_item_in_settings
    [:login_label, :logout_label]
  end

end
