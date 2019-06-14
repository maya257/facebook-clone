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
  before_save { [email.downcase!, first_name.capitalize!, last_name.capitalize!] }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :first_name, presence: true, length: { maximum: 35 }
  validates :last_name, presence: true, length: { maximum: 35 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,  length: { in: 3..255 }
                    # format: { with: VALID_EMAIL_REGEX },
                    # uniqueness: { case_sensitive: false }
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


  has_many :posts
  has_many :comments
  has_many :likes
  def full_name
  	"#{first_name} #{last_name}"
  end
                                 
end
