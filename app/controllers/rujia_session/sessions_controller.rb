require_dependency "rujia_session/application_controller"

module RujiaSession
  class SessionsController < ApplicationController

    def login
      session["return_to"] = request.referer if current_user.blank?
    end


    def login_post
      # 参数检查
      check_list = [{phone:'手机'}, {password:'密码'}]
      result = not_nil_check(params, check_list)

      unless result.blank?
        flash[:alert] = result[:error_msg]
        return redirect_to login_path
      end

      # 构造登录接口的请求参数
      url = HostConfig['jlm_api_host'] + "/api/v2/user/login"
      request = HTTPI::Request.new
      request.open_timeout = 10 # seconds
      request.read_timeout = 10 # seconds
      request.url = url
      request.body = {phone: params[:phone], password: params[:password]}
      begin
        response = HTTPI.post(request)
        if response.code != 200
          flash[:alert] = "远程服务器未知错误：#{response.code}"
          return redirect_to login_path
        end

        json = JSON.parse(response.body)
        if json['result_code'] != 0
          flash[:alert] = json['result']
          return redirect_to login_path
        end

        # 判断是否已经存在该用户
        users = User.select(:id).where("phone = ?", json['phone'])
        if users.blank?
          # 创建用户
          params[:user] = user_hash(json)
          # 创建新用户
          login_user = User.new(user_params)
          login_user.save
          sign_in login_user
        else
          # 每次登录更新用户信息
          params[:user] = user_hash(json)
          # 重新查找这个用户
          update_user = User.find(users[0].id)
          update_user.update_attributes(user_params)
          sign_in update_user
        end
        if session["return_to"].blank?
          redirect_to search_hotels_path
        else
          redirect_to session["return_to"]
        end
      rescue Exception => e
        Rails.logger.error("api/v2/user/login")
        Rails.logger.error(e.message)
        Rails.logger.error(e.backtrace.to_s)

        flash[:alert] = '登录失败：未知的服务器错误'
        return redirect_to login_path
      end
    end

    private

    def user_hash(json)
      user = Hash.new
      user['ctf_code'] = json['ctf_code']
      user['points'] = json['points']
      user['card_type'] = json['card_type']
      user['card_type_name'] = json['card_type_name']
      user['card_code'] = json['card_code']
      user['api_token'] = json['auth_token']
      user['balance'] = json['balance']
      user['name'] = json['name']
      user['rujia_id'] = json['code']
      user['phone'] = json['phone']
      user['user_name'] = "WAP" + json['phone']
      user['password'] = "WAP" + json['phone']
      if json['email'].blank? || json['email'] == "无"
        user['email'] = json['phone'] + "@wap.homeinns.com"
      else
        user['email'] = json['email']
      end
      user['card_level'] = json['card_level']
      user['account_level'] = json['account_level']
      user['account_desc'] = json['account_desc']
      user['nights'] = json['nights']
      user['next_level_nights'] = json['next_level_nights']
      user['down_expire_date'] = json['down_expire_date']
      unless json['already_live_in'].blank?
        if json['already_live_in']['Y'] == true
          user['live_in_heyi'] = true
        end
      end

      return user
    end

    def user_params
      params.require(:user).permit(:name, :sex, :ctf_type, :ctf_code, :points,
                                   :city, :card_type, :card_type_name, :card_code, :api_token, :balance,
                                   :user_name, :email, :password, :phone, :rujia_id, :card_level, :account_level,
                                   :account_desc, :nights, :next_level_nights, :down_expire_date, :live_in_heyi)
    end



  end
end
