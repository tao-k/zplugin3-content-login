class Login::ContentsController < Cms::Controller::Admin::Base
  layout  'admin/cms'

  def pre_dispatch
    return http_error(403) unless Core.user.root?
  end

  def index
    @items = Login::Content::User.paginate(page: params[:page], per_page: 10)
  end

  def install
    install_plugin
    flash[:notice] = "インストールを実行しました。"
    redirect_to zomeki_login_engine.url_for(action: :index)
  end

private

  def install_plugin
    `bundle exec rake zomeki_login_engine:install:migrations RAILS_ENV=#{Rails.env}`
    `bundle exec rake db:migrate SCOPE=zomeki_login_engine RAILS_ENV=#{Rails.env}`
  end

end
