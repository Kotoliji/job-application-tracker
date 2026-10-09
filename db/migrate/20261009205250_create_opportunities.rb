# frozen_string_literal: true

class CreateOpportunities < ActiveRecord::Migration[7.1]
  def change
    create_table :opportunities do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :title, null: false
      t.text :requirements
      t.text :product_description
      t.string :source_url
      t.date :found_at
      t.date :checked_at
      t.date :deadline
      t.integer :posting_status, null: false, default: 0
      t.integer :priority, null: false, default: 1
      t.integer :track, null: false, default: 0

      t.timestamps
    end

    add_index :opportunities, :posting_status
  end
end
