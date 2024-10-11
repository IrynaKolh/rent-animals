class ChangeCategoryToEnumInPets < ActiveRecord::Migration[7.1]
  def up
    remove_column :pets, :category
    add_column :pets, :category, :integer, default: 0, null: false
  end

  def down
    remove_column :pets, :category
    add_column :pets, :category, :string
  end
end
