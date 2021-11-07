class Dog < ApplicationRecord
  has_many_attached :images
  belongs_to :user, optional: true
  has_many :likes, dependent: :destroy
  has_many :liking_users, :through => :likes, :source => :user

  def assign_owner(user_id)
    update(user_id: user_id)
  end
end
