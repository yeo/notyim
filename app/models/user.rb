class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:github, :twitter]

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  field :name,               type: String
  field :admin,              type: Boolean, default: false
  field :providers,           type: Hash

  index({email: 1}, {background: true})
  index({admin: 1}, {background: true})

  validates_presence_of :email
  validates_uniqueness_of :email
  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  has_many :teams,  dependent: :destroy
  has_many :checks,  dependent: :destroy
  has_many :receivers, dependent: :destroy

  after_create :create_team

  # Get a list of verifi receiver
  # @return Criteria[Receiver]
  def verified_receivers
    Receiver.of_user(self).verified
  end

  # Get all assertion of this users, which is on their check
  def assertions
    Assertion.where(:check.in => check)
  end

  def self.from_omniauth(payload)
    email = payload.info.email
    return unless email

    user = User.where(email: email).first
    if !user
      user = User.create!(
        name: payload.info.name,
        email: payload.info.email,
        password: Devise.friendly_token[0,20],
        providers: {payload.provider => payload.uid}
      )
    else
      if !user.providers
        user.providers = {payload.provider => payload.uid}
        user.save
      end
    end

    user
  end

  # Attempt create first team automatically
  def create_team
    unless self.teams.present?
      self.teams = Team.create!(name: 'default team')
    end
  end
end
