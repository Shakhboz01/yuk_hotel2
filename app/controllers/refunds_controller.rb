class RefundsController < ApplicationController
  def index
    @q = Refund.ransack(params[:q])
    @refunds = @q.result.order(id: :desc)
    @sum = Refund.all.sum(:quantity)
    @refunds = @refunds.includes(:user, :product).page(params[:page]).per(40)
  end

  def new
    @refund = Refund.new
  end

  def create
    @refund = Refund.new(refund_params)
    @refund.user_id = current_user.id
    @refund.product_id = Product.find_by(weight: 1).id

    if @refund.save
      redirect_to refunds_path, notice: 'Создано успешно'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def refund_params
    params.require(:refund).permit(:user_id, :quantity, :product_id)
  end
end
