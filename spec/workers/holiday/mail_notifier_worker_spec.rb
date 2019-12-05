require 'rails_helper' 
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe Holiday::MailNotifierWorker, type: :worker do
  describe 'Testing worker' do
    it 'jobs are enqueued in the default queue' do
      expect(described_class.queue).to eq('default')
      expect(described_class).to be_processed_in(:default)
    end

    it 'ensures job is queued in sidekiq' do
      described_class.perform_async('mail_notifier', true)
      expect(described_class).to have_enqueued_sidekiq_job('mail_notifier', true)
    end

    it 'ensures it is retryable' do
      expect(described_class).to be_retryable(true)
    end 
  end
end
