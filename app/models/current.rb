class Current < ActiveSupport::CurrentAttributes
  attribute :session, :user
  attribute :user_agent, :ip_address
  attribute :entry, :play

  def session=(session)
    super
    self.user = session.user
  end
end
