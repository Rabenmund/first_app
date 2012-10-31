class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation, :nickname, :season_ids
  
  has_secure_password
  
  has_many :microposts, dependent: :destroy
  has_and_belongs_to_many :seasons
  has_many                :matchdays, through: :seasons
  has_and_belongs_to_many :winners, class_name: "Matchday", join_table: :matchdays_winners
  has_and_belongs_to_many :seconds, class_name: "Matchday", join_table: :matchdays_seconds
  
  
  has_many :tipps

  before_save do |user|  
    user.email = email.downcase
    user.deactivate! if user.deactivated == nil
  end
  
  before_save :create_remember_token
  
  validates :name, presence: true, length: { maximum: 20, minimum: 5 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :password_confirmation, presence: true, on: :create
  validates :nickname, presence: true, length: { maximum: 20, minimum: 5 }, uniqueness: { case_sensitive: false }

  def is_admin?
    admin
  end
  
  def name_role
    role = " (admin)" if is_admin?
    "#{name}#{role}"
  end
  
  def activate!
    update_attribute :deactivated, false  
  end
  
  def activated?
    !deactivated
  end
  
  def deactivated?
    deactivated
  end
  
  def deactivate!
    update_attribute :deactivated, true
  end
  
  def active_seasons
    seasons.where("finished = ?", false)
  end
  
  
  
  # to be done
  
  # def lock
  #   update_attribute :locked, true
  #   sessions.destroy_all
  # end
  # 
  # def unlock
  #   reset_bad_logons
  #   update_attribute :locked, false
  # end
  
  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end