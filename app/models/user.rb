class User < ApplicationRecord
	attr_accessor :activation_token #data baseに無いから書く必要がある
	has_many :microposts, dependent: :destroy#関係性は一番上に書く

	has_many :active_relationships, class_name: "Relationship",
									foreign_key: "follower_id", #activeつまりフォローをする者（その主体）を呼び出すキー
									dependent: :destroy
	has_many :following, through: :active_relationships,
						 source: :followed 

	has_many :passive_relationships, class_name: "Relationship",
									foreign_key: "followed_id", #activeつまりフォローをする者（その主体）を呼び出すキー
									dependent: :destroy
	has_many :followers, through: :passive_relationships
# ・user.active_relationships
# 　→relationship objects, from Relationship table
# ・user.following
# 　→user objects, from User table

	before_save :downcase_email #{ email.downcase! }  #callback #before_save {self.email = email.downcase}
	before_create :create_activation_digest

	validates :name, presence: true, length: {minimum: 5}

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i # emailを正規表現を使ってvalidates

	validates :email, 
					presence: true, 
					length: {minimum: 5},
					format: {with: VALID_EMAIL_REGEX}, #上で定義したvalidを使う
					uniqueness: {case_sensitive: false} #大文字も小文字も同じ内容と認識する

	has_secure_password
	# checks for password and password_confirmation
	# it will hash the passwor data and store it to password_digest column
	#gem 'bcrypt', '3.1.11'をインストールをすることでメソッドが使えるようになる。
	validates :password,
						length: {minimum: 6},
						allow_nil: true
	#has_secure_passwordの下にvalidatesを記入する必要がある。

	def feed  #全てのユーザーがフィードを持つからUserモデルで作るのが自然
		Micropost.where("user_id IN (?) OR user_id = ?", following_ids, id)
		#自分のポストとフォローしている人のマイクロポストを検索している
		#user_id IN ? はfollowing_ids、, user_id = ? は最後のidが代入される
		#ORはどちらもコールされる following_idsはfollowしている配列のfollowed IDだけを取り出せる(英語：take out)
	end


	 # ユーザーをフォローする
	def follow(other_user)
		following << other_user
		#↑followingのarrayにother_userを入れてる.上はフォローしてるユーザーを増やしている
		#self.following << other_user の略。Userモデルの中なので省略できている
	    #→これでもできる active_relationships.create(followed_id: other_user.id)
	end

	  # ユーザーをフォロー解除する
	def unfollow(other_user)
		following.delete(other_user)
		#self.following.delete(other_user)  の略。Userモデルの中なので省略できている
	    #これでもできるactive_relationships.find_by(followed_id: other_user.id).destroy
	end

	  # 現在のユーザーがフォローしてたらtrueを返す
	def following?(other_user)
	    following.include?(other_user)
	   	#self.following.include?(other_user)  の略。Userモデルの中なので省略できている
	   	 #self = user? 自身のインスタンス
	end

	def authenticated?(token)
		return false if activation_digest.nil?
		BCrypt::Password.new(activation_digest).is_password?(token) #true or false

	end


#モデルにメソッドを記述するときはオブジェクトを発行する時や他のコントローラーで使いたい時、
#allやwhere,findなどの予め与えられたメソッドを利用する時
	private

	def downcase_email
		email.downcase!
	end

	 def create_activation_digest #
      self.activation_token = SecureRandom.urlsafe_base64

      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      self.activation_digest = BCrypt::Password.create(self.activation_token, cost: cost)
end

end
