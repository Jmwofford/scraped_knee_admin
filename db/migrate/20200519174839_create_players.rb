class CreatePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.string :name
      t.string :height
      t.integer :jersey_num
      t.string :position
      t.string :teamName
      t.boolean :isAllStar
      t.string :player_link

      t.timestamps
    end
  end
end
