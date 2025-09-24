class Api::V1::PublicDataController < Api::V1::BaseController
    before_action :check_rate_limit!


    def index
      covid_cases = CovidCase.order(data: :desc).page(params[:page]).per(10)

      render json: {
        user_token: @current_user_token.email,
        current_page: covid_cases.current_page,
        total_pages: covid_cases.total_pages,
        total_count: covid_cases.total_count,
        data: covid_cases.as_json(only: [:regiao, :estado, :municipio, :data, :populacao_tcu2019, 
        :casos_acumulado, :casos_novos, :obitos_acumulado, :obitos_novos])
      }, status: :ok
    end

    private

    def check_rate_limit!
      key="rate-limit:#{@current_user_token.email}"
      count = Rails.cache.read(key).to_i

      if count >= 10
        render json: { error: "Limite de requisições atingido para o usuario: #{@current_user_token.email}" }, status: :too_many_requests
      else
        Rails.cache.write(key, count + 1, expires_in: 1.minute)
      end
    end
end