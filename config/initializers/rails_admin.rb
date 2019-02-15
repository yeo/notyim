# frozen_string_literal: true

RailsAdmin.config do |config|
  ### Popular gems integration

  # == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan
  config.authorize_with do |_controller|
    unless current_user.try(:admin?)
      flash[:error] = 'You are not an admin'
      redirect_to root_path
    end
  end

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.included_models = %w[
    User
    Team Invitation
    Check
    Incident
    Assertion
    Notification
    Receiver
    DailyUptime
    Verification
    AuditLog
    ChargeTransaction
    StripeToken
    Subscription
    Verification
    BotAccount
  ]
end
