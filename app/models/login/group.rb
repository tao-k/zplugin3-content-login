class Login::Group < ApplicationRecord
  include Sys::Model::Base
  include Sys::Model::Rel::Creator
  include Sys::Model::Rel::Editor

  has_many :users_groups, class_name: 'Login::UsersGroup'
  has_many :users, -> { order(:id) }, through: :users_groups

  enum_ish :state, [:enabled, :disabled], predicate: true

  def states
    [['有効','enabled'],['無効','disabled']]
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
