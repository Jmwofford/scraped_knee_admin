class CreateProperties < ActiveRecord::Migration[6.0]
  def change
    create_table :properties do |t|
      t.string :location_id
      t.string :state_abbrev
      t.string :state
      t.string :latitude
      t.string :longitude

      t.timestamps
    end
  end
end
