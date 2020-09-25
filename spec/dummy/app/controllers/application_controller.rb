# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_admin_user
    User.find_or_create_by!(username: 'AdminUser')
  end
end
