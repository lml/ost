class AddCreditClosesOptionToBfcs < ActiveRecord::Migration
  def change
    FeedbackCondition.find_each do |fc|
      fc.save!
    end
  end
end
