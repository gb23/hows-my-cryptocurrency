class TransactionsController < ApplicationController
    before_action :find_tx, only: [:show, :edit, :destroy]

    def new
        @transaction = Transaction.new
        @transaction.coin = Coin.new
    end

    def index
        @transactions = current_user.transactions
    end

    def edit
        if !authenticate(@transaction)
            redirect_to user_transactions_path(current_user), notice: "Only your own transactions are editable."
        end
    end

    def show
        if !authenticate(@transaction)
            redirect_to user_transactions_path(current_user), notice: "Only your own transactions are viewable."
        end
    end

    def update
        @transaction = Transaction.find(params[:id])

        @transaction.money_in = transaction_params[:money_in]
        @transaction.price_per_coin = transaction_params[:price_per_coin]
        if transaction_params[:coin_attributes][:name] == ""
            @transaction.coin_id = transaction_params[:coin_id]
        else
            @transaction.coin_id = nil
        end

        @transaction.coin = Coin.new if @transaction.coin.nil?
        @transaction.coin.name = transaction_params[:coin_attributes][:name] if @transaction.coin.id.nil?
        @transaction.coin.last_value = transaction_params[:coin_attributes][:last_value] if @transaction.coin.id.nil?
       
        @transaction.user_input = params[:transaction]

        if !params[:transaction][:coin_attributes][:name].empty? && !helpers.wallet_already_exists_for?(current_user,params[:transaction][:coin_attributes][:name].humanize.strip )
            current_user.wallets.build(name: @transaction.coin.name)
        end
        if @transaction.valid? && @transaction.coin.valid? 
            #want to do this only if creating a new wallet
            if !params[:transaction][:coin_attributes][:name].empty?
                
                if helpers.wallet_already_exists_for?(current_user, params[:transaction][:coin_attributes][:name].humanize.strip)
                    @transaction.coin = helpers.wallet_already_exists_for?(current_user, params[:transaction][:coin_attributes][:name].humanize.strip)
                    @transaction.coin.save
                else
                    @transaction.coin.save
                    current_user.wallets.last.coin =  @transaction.coin
                    current_user.wallets.last.save
                end
                @transaction.coin_id = @transaction.coin.id
            end

            @transaction.save

            redirect_to user_transactions_path(current_user), notice: "Transaction saved!"
        else
            # #if the user types in coin name, do this: 
            if !params[:transaction][:coin_attributes][:name].empty?
            #only want the last_value of 0 error if a coin was typed in. saving coin (below) with 0 value will cause error to show
                @transaction.coin.valid? 
            end

            render 'transactions/edit'
        end
    end

    def destroy
        @transaction.destroy 
        redirect_to user_transactions_path(current_user), notice: "Transaction has been deleted!"
    end

    def create
        @transaction = current_user.transactions.build(transaction_params)
        @transaction.user_input = params[:transaction]

        if !params[:transaction][:coin_attributes][:name].empty?
            current_user.wallets.build(name: @transaction.coin.name)
        end

        if @transaction.valid? && @transaction.coin.valid? #&& current_user.wallets.last.valid? 
            #want to do this only if creating a new wallet
            if !params[:transaction][:coin_attributes][:name].empty?
                @transaction.coin.save
                current_user.wallets.last.coin =  @transaction.coin
                current_user.wallets.last.save
                @transaction.coin_id = @transaction.coin.id
            end

            @transaction.save
            redirect_to user_transactions_path(current_user), notice: "Transaction saved!"
        else
            #if the user selects from drop down, that is the priority
            if params[:transaction][:coin_id].empty?
                @transaction.coin = Coin.new(name: params[:transaction][:coin_attributes][:name], last_value: params[:transaction][:coin_attributes][:last_value])
            end
            # #if the user doesnt select from the drop down, do this: 
            if !params[:transaction][:coin_attributes][:name].empty?
            #only want the last_value of 0 error if a coin wasn't typed in. saving coin with 0 value will cause error to show
                @transaction.coin.valid? 
            end
            render 'transactions/new'
        end
    end

    private
    def find_tx
        @transaction = Transaction.find_by(id: params[:id])
    end

    def transaction_params
        params.require(:transaction).permit(:money_in, :price_per_coin, :coin_id, coin_attributes: [:name, :last_value, :id]) 
    end

    def authenticate(transaction)
        if transaction.nil?
            false
        else
            current_user.transactions.find do |tx|
            tx.id == transaction.id 
            end
        end
    end
end