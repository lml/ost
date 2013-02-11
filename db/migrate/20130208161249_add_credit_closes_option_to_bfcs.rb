class AddCreditClosesOptionToBfcs < ActiveRecord::Migration
  def change
    BasicFeedbackCondition.find_each do |bfc|
      bfc.save!
    end
  end
end
