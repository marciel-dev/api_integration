class Api::V1::BaseController < ActionController::API
  before_action :authenticate_by_token!

  private

  def authenticate_by_token!
    token_value = request.headers["Authorization"].to_s.remove("Bearer ").strip
    token = Token.find_by(token: token_value)

    puts request.headers["Authorization"]
    if token.nil? || token.expired?
      render json: { error: "Token inválido ou expirado" }, status: :unauthorized
    else
      @current_user_token = token.user
    end
  end
end
