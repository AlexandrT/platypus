class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery
  protect_from_forgery with: :exception
end
