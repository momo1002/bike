# frozen_string_literal: true

class Spot < ApplicationRecord
  belongs_to :user
  has_many_attached :images
end
