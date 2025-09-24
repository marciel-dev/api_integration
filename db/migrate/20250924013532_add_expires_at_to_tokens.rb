class AddExpiresAtToTokens < ActiveRecord::Migration[8.0]
  def change
    add_column :tokens, :expires_at, :datetime
  end
end
