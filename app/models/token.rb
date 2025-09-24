class Token < ApplicationRecord
  belongs_to :user
  has_secure_token :token

  scope :active,   -> { where(inactivated_at: nil) }
  scope :inactivies, -> { where.not(inactivated_at: nil) }


  def expired?
    Time.now > expires_at
  end
end
