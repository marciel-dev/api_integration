class ImportCovidData < ActiveRecord::Migration[7.0]
  def up
    Rake::Task["import:covid"].invoke
  end

  def down
    CovidCase.delete_all
  end
end
