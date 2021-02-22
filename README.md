#テーブル設計

## users テーブル

| Column             | Type    | Options                   |
| ------------------ | ------- | ------------------------- |
| name               | string  | null: false               |
| email              | string  | null: false, unique: true |
| encrypted_password | string  | null: false               |
| phone_number       | string  |                           |
| profile            | text    | null: false               |
| prefecture_id      | integer | null: false               |


### Association

- has_many :rooms
- has_many :comments

## rooms テーブル

| Column         | Type       | Options                        |
| -------------- | ---------- | ------------------------------ |
| room_name      | string     | null :false                    |
| prefecture_id  | integer    | null :false                    |
| municipalities | string     | null: false                    |
| host_date      | datetime   | null :false                    |
| user           | references | null :false, foreign_key: true |


## Association

- has_many :comments
- belongs_to :user

## comments

| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| text   | text       | null :false                    |
| user   | references | null :false, foreign_key: true |
| room   | references | null :false, foreign_key: true |

## Association

- belongs_to :room
- belongs_to :user