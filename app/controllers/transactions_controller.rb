class TransactionsController < ApplicationController
    before_action :find_tx, only: [:show, :edit, :destroy, :update]

    def index
        byebug;
        #if tx has a coin_id, @transactions will be more selectibe query
        #coming from getJSON: <ActionController::Parameters {"coin_id"=>"1", "controller"=>"transactions", "action"=>"index", "user_id"=>"2"} permitted: false>
        if params[:coin_id].nil?
            @transactions = current_user.transactions
        else
            @transactions = Transaction.where(["user_id = ? and coin_id = ?", params[:user_id], params[:coin_id]])
        end
        
        respond_to do |f|
            f.html { render :index }
            f.json { render json: @transactions }
        end
        
    end

    def new
        @transaction = Transaction.new
        @transaction.coin = Coin.new
    end

    def create        
        @transaction = current_user.transactions.build(transaction_params)
        @transaction.user_input = params[:transaction]
        
        current_user.wallets.build(name: @transaction.coin.name) if @transaction.user_type_in_name_and_no_wallet_exits_yet(current_user)
        
        if @transaction.valid? && @transaction.coin.valid? 

            @transaction.save_coin_and_wallet_if_user_typed_in(current_user)

            @transaction.save
            redirect_to user_transactions_path(current_user), notice: "Transaction saved!"
        else
            @transaction.coin = Coin.new(name: @transaction.typed_in_coin_name, last_value: @transaction.typed_in_last_value) if @transaction.did_user_not_select_name?
            
            @transaction.run_validation_if_typed_in_name 

            render 'transactions/new'
        end
    end

    def show
        not_valid_transaction("view") if !authenticate(@transaction)
        # this example the author has an active model serializer
        #	@author = Author.find(params[:id])
		#	respond_to do |f|
		#		f.html { render :show }
		#		f.json { render json: @author }
		#	end

    end

    def edit
        not_valid_transaction("edit") if !authenticate(@transaction)
    end

  

    def update
        @transaction.user_input = params[:transaction]

        @transaction.money_in = transaction_params[:money_in]
        @transaction.price_per_coin = transaction_params[:price_per_coin]
        
        @transaction.did_user_not_type_in_name? ? @transaction.coin_id = transaction_params[:coin_id] : @transaction.coin_id = nil
        @transaction.init_coin if @transaction.coin_id.nil?

        current_user.wallets.build(name: @transaction.coin.name) if @transaction.user_type_in_name_and_no_wallet_exits_yet(current_user)

        if @transaction.valid? && @transaction.coin.valid? 

            @transaction.save_coin_possibly_wallet_if_user_typed_in_name(current_user)

            @transaction.save
            redirect_to user_transactions_path(current_user), notice: "Transaction saved!"
        else
            @transaction.run_validation_if_typed_in_name
            render 'transactions/edit'
        end
    end

    def destroy
        wallet = @transaction.user.wallets.find_by(name: @transaction.coin.name)
        coin_id = @transaction.coin_id
        negative_transaction = Transaction.new(user_id: current_user.id, coin_id: coin_id,
            money_in: (@transaction.money_in * -1), price_per_coin: @transaction.price_per_coin, 
            quantity: (@transaction.quantity * -1))

        wallet.update_wallet_with(negative_transaction)
        @transaction.destroy 

        #if user has no transactions with coin_id, delete wallet
        wallet.destroy if current_user.transactions.find_by(coin_id: coin_id).nil?
        
        redirect_to user_transactions_path(current_user), notice: "Transaction has been deleted!"
    end

   

    private

    def find_tx
        @transaction = Transaction.find_by(id: params[:id])
    end

    def transaction_params
        params.require(:transaction).permit(:money_in, :price_per_coin, :coin_id, :comment, coin_attributes: [:name, :last_value, :id]) 
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