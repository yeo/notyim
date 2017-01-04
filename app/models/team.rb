class Team
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  belongs_to :user

  scope :mine, ->(u) { where(user: u) }

  def format_as_json
    {id: self.id.to_s, name: name}
  end
end
