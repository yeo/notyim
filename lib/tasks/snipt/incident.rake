namespace :snipt do
  namespace :incident do

    desc "Test close incident"
    task close: :environment do
      return unless Rails.env.development?
      c = Check.where(uri: /noty/).first
      puts "Try to simulate close incident #{c.id}. Look out for email"

      result = {
        check_id: c.id.to_s,
        type: 'http',
        time: {
          total: 400,
        },
        body: 'ok',
        error: false
      }

      CheckToCreateIncidentWorker.perform_async(c.id.to_s, result.to_json)
    end

    desc "Test open incident"
    task open: :environment do
      c = Check.where(uri: /noty/).first
      puts "Try to simulate open incident #{c.id}. Look out for email"

      result = {
        check_id: c.id.to_s,
        type: 'http',
        time: {
          total: 400,
        },
        body: 'ok',
        error: true,
        error_message: 'connection refused',
      }

      CheckToCreateIncidentWorker.perform_async(c.id.to_s, result.to_json)
    end
  end
end
