class CreateCovidCases < ActiveRecord::Migration[8.0]
  def change
    create_table :covid_cases do |t|
      t.string :regiao
      t.string :estado
      t.string :municipio
      t.integer :coduf
      t.integer :codmun
      t.integer :cod_regiao_saude
      t.string :nome_regiao_saude
      t.date :data
      t.integer :semana_epi
      t.bigint :populacao_tcu2019
      t.integer :casos_acumulado
      t.integer :casos_novos
      t.integer :obitos_acumulado
      t.integer :obitos_novos
      t.integer :recuperados_novos
      t.integer :em_acompanhamento_novos
      t.integer :interior_metropolitana

      t.timestamps
    end
  end
end
