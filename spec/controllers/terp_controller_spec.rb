require 'spec_helper'

describe TerpController do

  describe "GET 'sign_in'" do
    it "returns http success" do
      get 'sign_in'
      response.should be_success
    end
  end

  describe "GET 'sign_up'" do
    it "returns http success" do
      get 'sign_up'
      response.should be_success
    end
  end

  describe "GET 'register'" do
    it "returns http success" do
      get 'register'
      response.should be_success
    end
  end

  describe "GET 'consent'" do
    it "returns http success" do
      get 'consent'
      response.should be_success
    end
  end

  describe "GET 'quiz_start'" do
    it "returns http success" do
      get 'quiz_start'
      response.should be_success
    end
  end

  describe "GET 'instructions'" do
    it "returns http success" do
      get 'instructions'
      response.should be_success
    end
  end

  describe "GET 'question_free_response'" do
    it "returns http success" do
      get 'question_free_response'
      response.should be_success
    end
  end

  describe "GET 'question_answer_selection'" do
    it "returns http success" do
      get 'question_answer_selection'
      response.should be_success
    end
  end

  describe "GET 'question_feedback'" do
    it "returns http success" do
      get 'question_feedback'
      response.should be_success
    end
  end

  describe "GET 'quiz_summary'" do
    it "returns http success" do
      get 'quiz_summary'
      response.should be_success
    end
  end

  describe "GET 'dashboard'" do
    it "returns http success" do
      get 'dashboard'
      response.should be_success
    end
  end

  describe "GET 'help'" do
    it "returns http success" do
      get 'help'
      response.should be_success
    end
  end

end
