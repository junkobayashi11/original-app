class Room < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :prefecture

  validates :room_name, :municipalities,presence: true
  validates :prefecture_id, numericality: { other_than: 1, message: "Select"}
  belongs_to :user
  has_many :comments, dependent: :destroy

  def self.search(search)
    if search != ""
      Room.where('room_name LIKE(?)', "%#{search}%")
    else
      Room.all
    end
  end
end
