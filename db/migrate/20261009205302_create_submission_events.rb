# frozen_string_literal: true

class CreateSubmissionEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :submission_events do |t|
      t.references :channel, null: false, foreign_key: true
      t.integer :event_type, null: false, default: 0
      t.datetime :occurred_at, null: false
      t.text :notes

      t.timestamps
    end
  end
end
