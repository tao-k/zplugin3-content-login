class Login::Content::User < Cms::Content
  default_scope { where(model: 'Login::User') }

  has_one :public_node, -> { public_state.where(model: 'Login::User').order(:id) },
  foreign_key: :content_id, class_name: 'Cms::Node'

  has_many :settings, -> { order(:sort_no) },
    foreign_key: :content_id, class_name: 'Login::Content::Setting', dependent: :destroy

  has_many :users, foreign_key: :content_id, class_name: 'Login::User', dependent: :destroy

  def redirect_url
    setting_value(:redirect_url)
  end

  def login_user
    account = Core.get_cookie('login_account')
    token   = Core.get_cookie('user_remember_token')
    return nil if account.blank? || token.blank?
    user_table = Login::User.arel_table
    self.users
      .where(user_table[:remember_token_expires_at].gteq(Time.now))
      .where(user_table[:remember_token].not_eq(nil))
      .where(account: account)
      .where(remember_token: token).first
  end

end