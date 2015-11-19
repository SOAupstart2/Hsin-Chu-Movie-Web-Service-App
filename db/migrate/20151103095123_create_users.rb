# Migration file for Users table
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :language, :location
      t.timestamps null: false
    end
  end
end
