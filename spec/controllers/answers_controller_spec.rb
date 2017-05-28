require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer)   { create(:answer) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'assigns creates a new answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'checks that answer correspond with question' do
      expect(assigns(:question).answers.first).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new answer in the db' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }
          .to change(question.answers, :count).by(1)
      end

      it 'redirect to question' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new answer in the db' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) } }
          .to_not change(Answer, :count)
      end

      it 'render new view' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }
        expect(response).to render_template :new
      end
    end
  end
end