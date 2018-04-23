class Login::User < ApplicationRecord
  include Sys::Model::Base
  include Sys::Model::Auth::Manager
  include Sys::Model::Rel::Creator
  include Sys::Model::Rel::Editor

  enum_ish :state, [:enabled, :disabled], predicate: true

  scope :organized_into, ->(group_ids) {
    joins(creator: :group).where(Sys::Group.arel_table[:id].in(group_ids))
  }
  # Content
  belongs_to :content, :foreign_key => :content_id, :class_name => 'Login::Content::User'
  validates :content_id, :presence => true

  def states
    [['有効','enabled'],['無効','disabled']]
  end

  def new_remember_token(expires)
    Util::String::Crypt.encrypt("#{content_id}-#{account}--#{expires}")
  end

  def creatable?
    return true if Core.user.has_priv?(:manager)
    Core.user.has_priv?(:create, item: content.concept_id, site_id: content.site_id)
  end

  def editable?
    return true if Core.user.has_priv?(:manager)
    Core.user.has_priv?(:update, item: content.concept_id, site_id: content.site_id)
  end

  def deletable?
    return true if Core.user.has_priv?(:manager)
    Core.user.has_priv?(:delete, item: content.concept_id, site_id: content.site_id)
  end

end
