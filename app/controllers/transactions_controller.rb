class TransactionsController < ApplicationController
  before_action :set_account

  def create
    @transaction = @account.transactions.build(transaction_params)
    if @transaction.save
      redirect_to @account, notice: "Transaction recorded."
    else
      redirect_to @account, alert: @transaction.errors.full_messages.to_sentence
    end
  end

  def destroy
    @transaction = @account.transactions.find(params[:id])
    @transaction.destroy
    redirect_to @account, notice: "Transaction deleted."
  end

  private

  def set_account
    @account = Account.find(params[:account_id])
  end

  def transaction_params
    params.require(:transaction).permit(:amount, :description, :category, :transaction_date)
  end
end
