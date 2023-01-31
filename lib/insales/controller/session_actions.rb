module Insales::Controller
  module SessionActions
    extend ActiveSupport::Concern

    included do
      skip_before_filter :insales_authenticate!, except: [:destroy]
    end

    def new
      # render
    end

    def create
      account = find_account_by_request
      return render_not_found unless account

      store_location(insales_success_login_path)
      insales_autologin_start(account)
    end

    def autologin
      if insales_autologin_finish
        redirect_to stored_location || insales_success_login_path
      else
        redirect_to action: :new
      end
    end

    def destroy
      insales_logout
      redirect_to action: :new
    end

    protected

    def render_not_found
      flash.now[:error] = t(:'.account_not_found').html_safe
      render action: :new
    end
  end
end
