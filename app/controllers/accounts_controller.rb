class AccountsController < ApplicationController
  before_action :set_account, only: %i[ show edit update destroy ]

  # GET /accounts or /accounts.json
  def index
    @accounts = Current.user.accounts
  end

  # GET /accounts/1 or /accounts/1.json
  def show
    # Update the show action to handle filtering and chart data:
    @transactions = @account.transactions.order(transaction_date: :desc)

    # Filter by category
    @transactions = @transactions.where(category: params[:category]) if params[:category].present?

    # Filter by date range
    @transactions = @transactions.where("transaction_date >= ?", params[:start_date]) if params[:start_date].present?
    @transactions = @transactions.where("transaction_date <= ?", params[:end_date]) if params[:end_date].present?

    # Data for charts (spending by category)
    # @chart_data = @account.transactions.group(:category).sum(:amount)
    @chart_data = @transactions.unscope(:order).group(:category).sum(:amount)
  end

  # GET /accounts/new
  def new
    @account = Current.user.accounts.build
  end

  # GET /accounts/1/edit
  def edit
  end

  def dashboard
    # Fetch only the accounts belonging to the currently logged-in user
    @accounts = Current.user.accounts.includes(:transactions)
    # Calculate the sum of all account balances for the header display
    @total_balance = @accounts.sum(:balance)
    # Fetch the 10 most recent transactions across ALL of the user's accounts
    @recent_transactions = Current.user.transactions.order(transaction_date: :desc).limit(10)
  end

  # POST /accounts or /accounts.json
  def create
    @account = Current.user.accounts.build(account_params)

    respond_to do |format|
      if @account.save
        format.html { redirect_to @account, notice: "Account was successfully created." }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end
  # PATCH/PUT /accounts/1 or /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to @account, notice: "Account was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1 or /accounts/1.json
  def destroy
    @account.destroy!

    respond_to do |format|
      format.html { redirect_to accounts_path, notice: "Account was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Current.user.accounts.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def account_params
      params.expect(account: [ :name, :balance ])
    end
end
