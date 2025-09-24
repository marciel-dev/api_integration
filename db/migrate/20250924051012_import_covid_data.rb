class ImportCovidData < ActiveRecord::Migration[7.0]
  def up
    Rake::Task["import:covid"].invoke
  end

  def down
    # rollback opcional, por exemplo limpar a tabela
    CovidCase.delete_all
  end
end
