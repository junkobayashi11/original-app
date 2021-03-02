class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :prefecture

  validates :profile, :name, presence: true
  validates :prefecture_id, numericality: { other_than: 1, message: 'Select' }
  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i.freeze
  validates_format_of :password, with: PASSWORD_REGEX, message: 'には英字と数字の両方を含めて設定してください'

  has_many :rooms
  has_many :comments
end
