class RegistrationsController < Devise::SessionsController
  def create
    super
    byebug
  end
end