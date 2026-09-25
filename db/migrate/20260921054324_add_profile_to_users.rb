# frozen_string_literal: true

class AddProfileToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :username, :string
    add_column :users, :icon_url, :string
    add_column :users, :location, :string
  end
end
