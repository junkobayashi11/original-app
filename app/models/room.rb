class Room < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :prefecture

  validates :room_name, :municipalities,presence: true
  validates :prefecture_id, numericality: { other_than: 1, message: "Select"}
  belongs_to :user
  has_many :commnets
end
