class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :dogs
  has_many :likes, dependent: :destroy
  has_many :liked_dogs, :through => :likes, :source => :dog

  def is_dogs_owner?(dog)
    id == dog.user_id
  end
end
