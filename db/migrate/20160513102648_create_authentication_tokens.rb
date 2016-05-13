class CreateAuthenticationTokens < ActiveRecord::Migration
  def change
    create_table :authentication_tokens do |t|
      t.string :authentication_token
      t.references :user, index: true

      t.timestamps
    end
  end
end
