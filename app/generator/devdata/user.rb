module Devdata
  module UserGenerator
    def self.generate
      ::User.create!(
        email: 'vinh@noty.im',
        password: '123456',
        name: 'Vinh',
        admin: true,
        confirmed_at: Time.now,
      )
    end
  end
end
