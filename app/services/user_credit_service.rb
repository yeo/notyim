class UserCreditService
  def self.initialize_credit(user)
    Credit.create!(user: user, sms: 0, voice_second: 0)
  end

  def self.has_credit_sms?(user)
    return false unless user.credit

    user.credit.sms >= 1
  end

  def self.has_credit_voice?(user)
    return false unless user.credit

    user.credit.voice_second >= 60
  end

  def self.deduct_sms!(user, team, amount=1)
    initialize_credit(user, team)
    user.reload
    credit = user.credit

    credit.sms -= 1
    credit.save!
  end

  def self.deduct_voice_minute!(user, team, amount=1)
    initialize_credit(user, team)
    user.reload

    user.credit.voice_second -= amount.minutes.to_i
    user.credit.save!
  end
end
