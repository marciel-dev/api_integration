require 'swagger_helper'

RSpec.describe 'api/v1/public_data', type: :request do
  path '/api/v1/public_data' do
    get 'Lista casos de COVID' do
      tags 'CovidCases'
      produces 'application/json'
      security [ bearerAuth: [] ]

      parameter name: :page, in: :query, type: :integer, description: 'Número da página'

      response '200', 'sucesso' do
        let(:user)  { User.create!(email: 'teste@x.com', password: '123456') }
        let(:token) { Token.create!(user:, expires_at: 10.minutes.from_now) }
        let(:Authorization) { "Bearer #{token.value}" }

        run_test!
      end

      response '401', 'não autorizado' do
        let(:Authorization) { "Bearer INVALIDO" }
        run_test!
      end
    end
  end
end
