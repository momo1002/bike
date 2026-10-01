class Spot < ApplicationRecord
  belongs_to :user
  has_many_attached :images

  validates :title,
            presence: { message: "を入力してください" }

  validates :description,
            presence: { message: "を入力してください" }

  validates :address,
            presence: { message: "を入力してください" }

  validate :images_presence

  private

  def images_presence
    errors.add(:images, "を選択してください") unless images.attached?
  end
end