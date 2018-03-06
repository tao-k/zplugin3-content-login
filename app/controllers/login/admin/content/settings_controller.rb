class Login::Admin::Content::SettingsController < Cms::Admin::Content::SettingsController
  def model
    Login::Content::Setting
  end
end
