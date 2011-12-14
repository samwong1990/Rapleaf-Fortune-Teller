class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.string :name
      t.string :email
      t.string :dataset

      t.timestamps
    end
  end
end
