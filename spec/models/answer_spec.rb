# frozen_string_literal: true

require_relative 'models_helper'

RSpec.describe Answer, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it { should belong_to :question }
  it { should have_many(:attachments) }
  it { should validate_presence_of :body }

  it { should have_db_column :question_id }
  it { should have_db_column :user_id }
  it { should have_db_column :best }

  it { should accept_nested_attributes_for :attachments }

  it_behaves_like 'votable'

  describe 'set best:true to answer' do
    let!(:question)     { create(:question) }
    let!(:answer)       { create(:answer, question: question, best: false) }
    let!(:answer2)      { create(:answer, question: question, best: true) }

    it 'set best:true to one answer' do
      answer.set_best
      expect(answer.best).to eq true
    end

    it 'set best:false to another answer' do
      answer2.set_best
      expect(answer.best).to eq false
    end
  end

  describe '.send_new_answer_notification' do
    let(:question)      { create(:question) }
    let(:answer)        { build(:answer, question: question) }
    let!(:subscription) { create(:subscription, question: question) }

    it 'is working when asnwer created' do
      expect(answer).to receive(:send_new_answer_notification)
      answer.save
    end

    it 'is calling QuestionUpdateMailer while working' do
      expect(AnswerNotificationJob).to receive(:perform_later).with(answer).and_call_original
      answer.save
    end
  end
end
