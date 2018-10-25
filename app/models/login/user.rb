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

  has_many :users_groups, foreign_key: :user_id, class_name: 'Login::UsersGroup', dependent: :destroy
  has_many :groups, through: :users_groups, source: :group

  after_save :save_group, if: -> { @_in_group_id_changed }

  def group(load = nil)
    groups[0]
  end

  def group_id(load = nil)
    (g = group(load)) ? g.id : nil
  end

  def in_group_id
    unless @in_group_id
      @in_group_id = group.try(:id)
    end
    @in_group_id
  end

  def in_group_id=(value)
    @_in_group_id_changed = true
    @in_group_id = value
  end

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

protected


  def save_group
    exists = (users_groups.size > 0)

    users_groups.each_with_index do |rel, idx|
      if idx == 0 && !in_group_id.blank?
        if rel.group_id != in_group_id
          rel.class.where(user_id: rel.user_id, group_id: rel.group_id).update_all(group_id: in_group_id)
          rel.group_id = in_group_id
        end
      else
        rel.class.where(user_id: rel.user_id, group_id: rel.group_id).delete_all
      end
    end

    if !exists && !in_group_id.blank?
      rel = Login::UsersGroup.create(
        user_id: id,
        group_id: in_group_id
      )
    end

    return true
  end


end
