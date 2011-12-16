class CreateConsultings < ActiveRecord::Migration
  def change
    create_table :consultings do |t|
      t.string :session
      t.string :name
      t.string :email
      t.string :dataset
      t.string :hasheddataset

      t.timestamps
    end
  end
end
