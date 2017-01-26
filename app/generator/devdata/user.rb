module Devdata
  module User
    def generate
      User.create!(
        email: 'vinh@noty.im',
        password: '12345',
        name: 'Vinh',
        admin: true
      )
    end
  end
end
