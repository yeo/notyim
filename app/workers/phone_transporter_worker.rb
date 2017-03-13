class PhoneTransporterWorker
  include Sidekiq::Worker

  def perform(receiver_id, url)
    receiver = Receiver.find(receiver_id)
    ::Yeller::Transporter::Phone.call(receiver.handler, url)
  end
end
