require 'csv'

namespace :import do
  desc "Importa dados COVID de um CSV"
  task covid: :environment do
    file_path = ENV['FILE']

    unless file_path && File.exist?(file_path)
      puts "Passe o caminho do arquivo: rake import:covid FILE=path/arquivo.csv"
      exit
    end

    puts "Importando dados de #{file_path}..."

    CSV.foreach(file_path, headers: true, col_sep: ",").with_index(1) do |row, i|
      CovidCase.create!(
        regiao: row['regiao'],
        estado: row['estado'],
        municipio: row['municipio'],
        coduf: row['coduf'],
        codmun: row['codmun'].presence,
        cod_regiao_saude: row['codRegiaoSaude'].presence,
        nome_regiao_saude: row['nomeRegiaoSaude'].presence,
        data: row['data'],
        semana_epi: row['semanaEpi'],
        populacao_tcu2019: row['populacaoTCU2019'],
        casos_acumulado: row['casosAcumulado'],
        casos_novos: row['casosNovos'],
        obitos_acumulado: row['obitosAcumulado'],
        obitos_novos: row['obitosNovos'],
        recuperados_novos: row['Recuperadosnovos'],
        em_acompanhamento_novos: row['emAcompanhamentoNovos'],
        interior_metropolitana: row['interior/metropolitana']
      )
      break if i >= 1000
    end

    puts "Importação concluída!"
  end
end
