class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include PrettyId

  field :firstname
  field :lastname

  has_and_belongs_to_many :schools, class_name: "School", inverse_of: :students

  has_many :created_items, class_name: "Item", inverse_of: "creator"
  has_many :comments, class_name: "Comment", inverse_of: "author"

  has_and_belongs_to_many :hated_items, class_name: "Item", inverse_of: "haters"
  has_and_belongs_to_many :liked_items, class_name: "Item", inverse_of: "likers"
  has_and_belongs_to_many :loved_items, class_name: "Item", inverse_of: "lovers"


  #{{{ devise
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable
  devise :omniauthable, :omniauth_providers => [:facebook]

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

  # Confirmable
  field :confirmation_token,   type: String
  field :confirmed_at,         type: Time
  field :confirmation_sent_at, type: Time
  field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  def sign_in_json
    {
      id: pretty_id,
      email: email,
      firstname: firstname,
      lastname: lastname,
    }
  end
  #}}}

  def public_email(who_asks)
    public_email = if who_asks == self
                     email
                   else
                     :hidden
                   end
  end

  def confirmed_user?
    confirmed? or provider.to_s == "facebook"
  end

  def evaluate_item!(item,score)
    raise "#{item} is no Item" unless item.is_a? Item
    raise "score should be in [0..3]" unless score.is_a? Integer and score >= 0 and score <= 3

      item.haters.delete(self)
      item.likers.delete(self)
      item.lovers.delete(self)

      if score == 1
        item.haters << self
      elsif score == 2
        item.likers << self
      elsif score == 3
        item.lovers << self
      end

      if loved_item_ids_changed? or liked_item_ids_changed? or loved_item_ids_changed?
        item.save
        self.save
      end

  end

end
