module SessionsHelper

	def log_in(user)
		session[:user_id] = user.id
		#:user_idは自分で定義できる
	end

	def current_user
		@current_user ||= User.find_by(id: session[:user_id])
		# ↑とイコール@current_user = @current_user || User.find_by(session[:user_id])
		# User.find(session[:user_id])
		# ↑ sessionがnilの時に正しく動作するのはfind_by
		# 以下と同じことをしている
		# #if @current_user
		# 	@current_user
		# else
		# 	@current_user = User.find_by(session[:user_id])
		# end
		#current_userメソッドが１リクエスト内で何度も呼び出されると、
		#呼び出された回数と同じだけデータベースにも問い合わせされてしまう点
		#す。そこでRubyの慣習に従って、User.find_byの実行結果を
		#インスタンス変数に保存することにします。こうすることでデータベースの読み出しは最初の一回だけになり、
		#以後の呼び出しではインスタンス変数を返すようになります。地味なようですが、Railsを高速化させるための重要なテクニックです

	end

	def current_user?(user)
		user == current_user
	end


	def logged_in? #true or false
		!current_user.nil?
		#ただ、!@current_user.nil??でエラーを起こすのは何故か良くわからん。
	end

	def log_out
		session.delete(:user_id)
		@current_user = nil #こっちで発行した発行したインスタンスが生きてるから削除する必要がある
	end

	def redirect_back_or(user)
		redirect_to(session[:forwarding_url] || user) # もしforwarding_urlがあれば遷移し、なければuserのshowに飛ぶ（path)
		session.delete(:forwarding_url)
	end

	def store_location
		session[:forwarding_url] = request.original_url if request.get?
		# if request.get? #もしrequestがgetメソッドだったら
		# session[:forwarding_url] = request.original_url #original_urlの中にURLが入っている
		# end
	end

# インスタンス変数@current_userをnilにする必要があるのは、
# @current_userがdestroyアクションより前に作成され (作成されていない場合)、かつ、
# リダイレクトを直接発行しなかった場合だけです。
# 今回はリダイレクトを直接発行しているので、不要です。
# 現実にこのような条件が発生する可能性はかなり低く、
#このアプリケーションでもこのような条件を作り出さないように開発しているので、本来はnilに設定する必要はないのですが、ここではセキュリティ上の死角を万が一にでも作り出さないためにあえてnilに設定しています。


	# def logged_in_user #true or false
	# 	if !current_user.nil?
	# 		redirect_to current_user
	# 	else
	# 		flash[:danger] = "Please Login"
	# 		redirect_to login_path
	# 	end

	# end


end
