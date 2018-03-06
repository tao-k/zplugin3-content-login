class Login::User < ApplicationRecord
  include Sys::Model::Base
  include Sys::Model::Auth::Manager

  enum_ish :state, [:enabled, :disabled], predicate: true

  # Content
  belongs_to :content, :foreign_key => :content_id, :class_name => 'Login::Content::User'
  validates :content_id, :presence => true

  def states
    [['有効','enabled'],['無効','disabled']]
  end

  def new_remember_token(expires)
    Util::String::Crypt.encrypt("#{content_id}-#{account}--#{expires}")
  end

end
