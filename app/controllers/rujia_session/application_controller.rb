module RujiaSession
  class ApplicationController < ActionController::Base
      def not_nil_check(params,check_list)
        check_list.each do |item|
          if params[item.keys[0]].blank?
            return {error_msg: "#{item.values[0]} 不能为空！", result_code: 0}
          end
        end

        return nil
      end
  end
end
