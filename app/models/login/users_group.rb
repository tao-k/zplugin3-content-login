class Login::UsersGroup < ApplicationRecord
  include Sys::Model::Base
  belongs_to :user
  belongs_to :group

end
