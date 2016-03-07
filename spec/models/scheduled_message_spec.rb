require "rails_helper"

describe ScheduledMessage do
  describe "Associations" do
    it { should have_many(:sent_scheduled_messages).dependent(:destroy) }
  end

  describe "Validations" do
     it { should validate_presence_of(:body) }
     it { should validate_presence_of(:days_after_start) }
     it { should validate_presence_of(:tag_list) }
     it { should validate_presence_of(:time_of_day) }
     it { should validate_presence_of(:title) }
  end

  describe '.date_time_ordering' do
    let(:tags) { ['testing', 'testing2'] }
    let!(:message1) do
      ScheduledMessage.create!(title: 'test1',
                               body: 'this is the first test',
                               days_after_start: 1,
                               time_of_day: '2000-01-01 16:00:00 UTC',
                               tag_list: tags)
    end

    let!(:message2) do
      ScheduledMessage.create!(title: 'test2',
                               body: 'this is the second test',
                               days_after_start: 1,
                               time_of_day: '2000-01-01 14:00:00 UTC',
                               tag_list: tags)
    end

    let!(:message3) do
      ScheduledMessage.create!(title: 'test3',
                               body: 'this is the third test',
                               days_after_start: 1,
                               time_of_day: '2000-01-01 11:00:00 UTC',
                               tag_list: tags)
    end

    it 'should display the messages in chronological order' do
      expect(ScheduledMessage.date_time_ordering.first).to eq(message3)
    end
  end
end
