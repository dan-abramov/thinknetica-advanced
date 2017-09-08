class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource class: :profile

  def me
    respond_with current_resource_owner
  end

  def index
    respond_with User.where.not(id: current_resource_owner.id)
  end
  protected

  def current_ability
    @ability = Ability.new(current_resource_owner)
  end
end
