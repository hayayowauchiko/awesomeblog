class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> {order(created_at: :desc)} #anonymous function lambda
  mount_uploader :picture, PictureUploader
  #CarrierWaveに画像と関連付けたモデルを伝えるためには、mount_uploaderというメソッドを使います。
  #このメソッドは、引数に属性名のシンボルと生成されたアップローダーのクラス名を取ります。これによりmicropostモデルにpictureが追加される
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate :picture_size

private

 def picture_size
 	if picture.size > 5.megabytes
	   errors.add(:picture, "should be less than 5MB")
	end
 end

end