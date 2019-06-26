# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  birth_date             :date
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  gender                 :string
#  last_name              :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  before_save { [first_name.capitalize!, last_name.capitalize!] }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :first_name, presence: true, length: { maximum: 35 }
  validates :last_name, presence: true, length: { maximum: 35 }
  validates :email, length: { maximum: 255 }
  validates :gender, presence: true, inclusion: { in: %w(Male Female),
    message: "%{value} is not a valid gender" }
  VALID_BIRTHDATE_REGEX = /([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]))/
  validates :birth_date, presence: true, 
                         format: { 
                         with: VALID_BIRTHDATE_REGEX,  
                         message: "%{value} is not a valid date format of YYYY-MM-DD" 
                        }
  validates :password, presence: true, 
                       length: { in: 6..20 }


  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :active_friend_requests, class_name: 'FriendRequest',
                                    foreign_key: 'requester_id',
                                    dependent: :destroy
  has_many :passive_friend_requests, class_name: 'FriendRequest',
                                     foreign_key: 'requestee_id',
                                     dependent: :destroy

  has_many :sent_requests, through: :active_friend_requests,
                                    source: :requestee
  has_many :received_requests, through: :passive_friend_requests,
                                        source: :requester

  has_many :active_friendships, foreign_key: :active_friend_id,
                                class_name: 'Friendship',
                                dependent: :destroy
  has_many :passive_friendships, foreign_key: :passive_friend_id, 
                                 class_name: 'Friendship',
                                 dependent: :destroy


  has_many :active_friends, through: :active_friendships 
  has_many :passive_friends, through: :passive_friendships


  # def full_name
  # 	"#{first_name} #{last_name}"
  # end

  # def friends
  #   active_friends + passive_friends
  # end
                                 
end
