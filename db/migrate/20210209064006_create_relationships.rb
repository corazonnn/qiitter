class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      t.references :user, foreign_key: true
      t.references :follow, foreign_key: { to_table: :users }

      t.timestamps
      t.index [:user_id, :follow_id], unique: true #user_idとfollow_idは重複不可。つまり同じ人を何度もフォローできない。
    end
  end
end
