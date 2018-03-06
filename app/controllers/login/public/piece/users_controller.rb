class Login::Public::Piece::UsersController < Sys::Controller::Public::Base
  include Zplugin3::Content::Login::Auth::Base

  def pre_dispatch
    @content = ::Login::Content::User.find_by(id: Page.current_piece.content_id)
    return http_error(404) unless @content
  end

  def index
    @login_user = @content.login_user
    @node = @content.public_node
    if @node
      @login_uri = "#{@node.public_uri}login"
      @logout_uri = "#{@node.public_uri}logout"
    end
  end

end