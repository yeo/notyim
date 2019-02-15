# frozen_string_literal: true

# require 'yeller'
namespace :snipt do
  namespace :incident do
    desc 'Test close incident'
    task close: :environment do
      return unless Rails.env.development?

      c = Check.where(uri: /noty/).first
      puts "Try to simulate close incident #{c.id}. Look out for email"

      result = {
        check_id: c.id.to_s,
        type: 'http',
        time: {
          total: 400
        },
        body: 'ok',
        error: false
      }

      CheckToCreateIncidentWorker.perform_async(c.id.to_s, result.to_json)
    end

    desc 'Test open incident'
    task open: :environment do
      c = Check.where(uri: /noty/).first
      puts "Try to simulate open incident #{c.id}. Look out for email"

      result = {
        check_id: c.id.to_s,
        type: 'http',
        time: {
          total: 400
        },
        body: 'ok',
        error: true,
        error_message: 'connection refused'
      }

      CheckToCreateIncidentWorker.perform_async(c.id.to_s, result.to_json)
    end

    desc 'Test notifiy inident'
    task notityf: :environment do
      i = Incident.first
      r = Receiver.find('58c25f328c245582a3495b7b')
      Yeller::Provider::Hipchat.notify_incident(i, r)
    end

    desc 'Test notifiy email'
    task email_notify: :environment do
      Incident.find '58c61f198c2455218f8754b7'
    end
  end
end
