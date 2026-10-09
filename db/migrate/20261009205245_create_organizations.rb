# frozen_string_literal: true

class CreateOrganizations < ActiveRecord::Migration[7.1]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.integer :kind, null: false, default: 0
      t.string :location
      t.string :website
      t.text :notes

      t.timestamps
    end
  end
end
