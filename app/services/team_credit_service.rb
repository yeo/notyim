# frozen_string_literal: true

class TeamCreditService
  def self.initialize_credit(team)
    Credit.create!(team: team, sms: 0, voice_second: 0)
  end

  def self.enough_credit_sms?(team)
    return false unless team.credit

    team.credit.sms >= 1
  end

  def self.enough_credit_voice?(team)
    return false unless team.credit

    team.credit.voice_second >= 60
  end

  def self.deduct_sms!(team, _amount = 1)
    initialize_credit(team, team)
    team.reload
    credit = team.credit

    credit.sms -= 1
    credit.save!
  end

  def self.deduct_voice_minute!(team, amount = 1)
    initialize_credit(team, team)
    team.reload

    team.credit.voice_second -= amount.minutes.to_i
    team.credit.save!
  end
end
