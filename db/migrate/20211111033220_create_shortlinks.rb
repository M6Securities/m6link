class CreateShortlinks < ActiveRecord::Migration[6.1]
  def change
    create_table :shortlinks do |t|

      t.string :shortcut
      t.string :url
      t.bigint :clicks, default: 0

      t.index :shortcut, unique: true

      t.timestamps
    end
  end
end
