class Login::Admin::Content::BaseController < Cms::Admin::Content::BaseController
  layout  'admin/cms'
  def model
    Login::Content::User
  end

end