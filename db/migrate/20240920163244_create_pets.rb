class CreatePets < ActiveRecord::Migration[7.1]
  def change
    create_table :pets do |t|
      t.string :name
      t.decimal :price
      t.integer :age
      t.string :category
      t.boolean :delivery_to_client
      t.boolean :insuranse
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
