# frozen_string_literal: true

# Trinity
module Trinity
  # Share Urls
  module Utils
    # URL handling
    class Url
      include Rails.application.routes.url_helpers
      # extend self

      def self.instance
        @instance ||= new
      end

      def self.to(method, *args)
        if Rails.env.production?
          instance.send("#{method}_url", *args)
        else
          path = instance.send("#{method}_path", *args)
          "#{Rails.configuration.local_proxy_public}#{path}"
        end
      end
    end
  end
end
