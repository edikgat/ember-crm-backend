require 'roar/json'
require 'roar/decorator'
class SupportRequestPresenter < Roar::Decorator
  include Roar::JSON
  property :id
  property :subject, render_nil: true
  property :status
  property :notes, render_nil: true
  property :user_name, render_nil: true, exec_context: :decorator

  private

  def user_name
    represented.user.full_name
  end
end
