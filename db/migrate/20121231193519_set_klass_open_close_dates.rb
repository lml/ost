class SetKlassOpenCloseDates < ActiveRecord::Migration
  def up
    Klass.find_each do |klass|
      klass.open_date  = klass.start_date - 1.week
      klass.close_date = klass.end_date   + 1.month
      klass.save!
    end
  end

  def down
  end
end
