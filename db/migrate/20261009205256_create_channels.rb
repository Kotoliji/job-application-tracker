# frozen_string_literal: true

class CreateChannels < ActiveRecord::Migration[7.1]
  def change
    create_table :channels do |t|
      t.references :opportunity, null: false, foreign_key: true
      t.integer :channel_type, null: false, default: 0
      t.integer :outcome_status, null: false, default: 0
      t.string :link
      t.string :contact_name
      t.string :contact_email
      t.string :cv_version
      t.datetime :sent_at
      t.datetime :follow_up_at

      t.timestamps
    end

    add_index :channels, :outcome_status
    add_index :channels, :follow_up_at
  end
end
