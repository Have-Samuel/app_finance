class TransactionsController < ApplicationController
  before_action :set_account

  def create
    @transaction = @account.transactions.build(transaction_params)

    respond_to do |format|
      if @transaction.save
        format.turbo_stream
        format.html { redirect_to @account, notice: "Transaction recorded." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("new_transaction", partial: "transactions/form", locals: { account: @account, transaction: @transaction }) }
        format.html { redirect_to @account, alert: @transaction.errors.full_messages.to_sentence }
      end
    end
  end

  def destroy
    @transaction = @account.transactions.find(params[:id])
    @transaction.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @account, notice: "Transaction deleted." }
    end
  end

  private

  def set_account
    @account = Current.user.accounts.find(params[:account_id])
  end

  def transaction_params
    params.require(:transaction).permit(:amount, :description, :category, :transaction_date)
  end
end
