# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def github
      omniauth!
    end

    def twitter
      omniauth!
    end

    private

    def omniauth!
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user&.persisted?
        sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
        flash[:notice] = 'You have successfully authenticated'
      else
        flash[:notice] = 'Please make sure you allow us to read email'
        redirect_to root_url
      end
    end
  end
end
