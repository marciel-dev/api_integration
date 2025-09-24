class TokensController < ApplicationController
  before_action :authenticate_user!

  def index
    @tokens = current_user.tokens.order(created_at: :desc)
  end

  def show
  end

  def create
    Token.active.update(inactivated_at: Time.now)
    @token = current_user.tokens.build(expires_at: 10.minutes.from_now)

    if @token.save
      redirect_to '/tokens', notice: "Novo token gerado. #{ @token.token } Expira às #{@token.expires_at.strftime('%H:%M:%S')}"
    else
      redirect_to '/tokens', alert: "Erro ao gerar token."
    end
  end

  def destroy
  end

  def new
  end
end
