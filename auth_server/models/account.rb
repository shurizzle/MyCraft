class Account
  include DataMapper::Resource
  attr_accessor :password, :password_confirmation, :email_confirmation

  property :id, Serial
  property :nick, String, unique: true
  property :email, String
  property :crypted_password, String
  property :salt, String
  property :session_hash, String
  property :server_hash, String

  validates_presence_of     :email, :nick
  validates_presence_of     :password,                    :if => :password_required
  validates_presence_of     :password_confirmation,       :if => :password_required
  validates_length_of       :password, :within => 4..40,  :if => :password_required
  validates_confirmation_of :password,                    :if => :password_required
  validates_confirmation_of :email
  validates_length_of       :email, :within => 3..100
  validates_uniqueness_of   :email, :case_sensitive => false
  validates_uniqueness_of   :nick,  :case_sensitive => false
  validates_format_of       :email,    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_format_of       :nick,     :with => /\A[a-z0-9_-]+\Z/i

  before :save, :generate_password

  def self.authenticate (nick, password)
    account = first(:nick => nick) if email.present?
    account && account.password_clean == password ? account : nil
  end

  def self.find (id)
    find_by_id(id)
  end

  def self.find_by_id (id)
    first(id: id) rescue nil
  end

  alias __set_password__ password=
  def password= (pass)
    __set_password__(pass).tap {
      generate_password
    }
  end

  def password_clean
    crypted_password.decrypt(salt)
  end

  private
  def generate_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now}--#{email}--") if new?
    self.crypted_password = password.encrypt(self.salt)
  end

  def password_required
    crypted_password.blank? || !password.blank?
  end
end
