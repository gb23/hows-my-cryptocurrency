class TransactionsController < ApplicationController
    before_action :find_tx, only: [:show, :edit, :destroy, :update]

    def new
        @transaction = Transaction.new
        @transaction.coin = Coin.new
    end

    def index
        @transactions = current_user.transactions
    end

    def edit
        not_valid_transaction("edit") if !authenticate(@transaction)
    end

    def show
        not_valid_transaction("view") if !authenticate(@transaction)
    end

    def update
        @transaction.user_input = params[:transaction]

        @transaction.money_in = transaction_params[:money_in]
        @transaction.price_per_coin = transaction_params[:price_per_coin]
        
        @transaction.did_user_not_type_in_name? ? @transaction.coin_id = transaction_params[:coin_id] : @transaction.coin_id = nil
        @transaction.init_coin if @transaction.coin_id.nil?

        current_user.wallets.build(name: @transaction.coin.name) if @transaction.user_type_in_name_and_no_wallet_exits_yet(current_user)

        if @transaction.valid? && @transaction.coin.valid? 
            if !@transaction.did_user_not_type_in_name?
                if @transaction.wallet_already_exists_for?(current_user, @transaction.typed_in_coin_name)
                    @transaction.coin = @transaction.wallet_already_exists_for?(current_user, @transaction.typed_in_coin_name)
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
            if !@transaction.did_user_not_type_in_name?
                #only want the last_value of 0 error if a coin was typed in. 
                #by seeing if coin is valid (below) with 0 value will cause error to show
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
        
        current_user.wallets.build(name: @transaction.coin.name) if @transaction.user_type_in_name_and_no_wallet_exits_yet(current_user)
        
        if @transaction.valid? && @transaction.coin.valid? 
            if !@transaction.did_user_not_type_in_name?
                @transaction.coin.save
                @transaction.coin_id = @transaction.coin.id

                wallet = @transaction.wallet_last_or_find_for(current_user)
           
                wallet.coin =  @transaction.coin
                wallet.save
            end
            @transaction.save
            redirect_to user_transactions_path(current_user), notice: "Transaction saved!"
        else
            @transaction.coin = Coin.new(name: @transaction.typed_in_coin_name, last_value: @transaction.typed_in_last_value) if @transaction.did_user_not_select_name?
    
            if !@transaction.did_user_not_type_in_name?
                #only want the last_value of 0 error if a coin wasn't typed in. 
                #by seeing if coin is valid (below) with 0 value will cause error to show
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

    def not_valid_transaction(action)
        redirect_to user_transactions_path(current_user), notice: "Only your own transactions are #{action}able."
    end
end