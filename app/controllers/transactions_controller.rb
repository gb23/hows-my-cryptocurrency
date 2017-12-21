class TransactionsController < ApplicationController
    before_action :find_tx, only: [:show, :edit, :destroy, :update]

    def index
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
        
        if @transaction.valid? && (!@transaction.coin.nil? && @transaction.coin.valid?) 

            @transaction.save_coin_and_wallet_if_user_typed_in(current_user)
            @transaction.save
            
            respond_to do |f|
                f.json{render json: @transaction.attributes.merge({user_id: current_user.id}).merge({coin_name:@transaction.coin.name}), status: 201 }
                f.html{redirect_to user_transactions_path(current_user), notice: "Transaction saved!"}
               
            end
        else
            #these two lines are for validation error generation if using HTML request
            @transaction.coin = Coin.new(name: @transaction.typed_in_coin_name, last_value: @transaction.typed_in_last_value) if @transaction.did_user_not_select_name?
            @transaction.run_validation_if_typed_in_name 

            notesPresent = transaction_params.keys.detect{|key| key == "note_attributes"}
            if notesPresent
                notes = transaction_params[:note_attributes][:comments]
            else
                notes = nil
            end
            if @transaction.did_user_not_select_name? && !@transaction.did_user_leave_default_blank_name? #user does NOT choose "not listed..." from drop down selection
                respond_to do |f|
                    f.json{render json: @transaction.attributes.merge({user_id: current_user.id}.merge({coin_id:transaction_params[:coin_id]}.merge({last_value:transaction_params[:coin_attributes][:last_value]}.merge({notes: notes}.merge({form: "open"}.merge({coin_name:transaction_params[:coin_attributes][:name]}))))))}  
                    f.html{render 'transactions/new' } 
                end
            else #user chooses "not listed..." from drop down selection
                respond_to do |f|
                    f.json{render json: @transaction.attributes.merge({user_id: current_user.id}.merge({coin_id:transaction_params[:coin_id]}.merge({last_value:transaction_params[:coin_attributes][:last_value]}.merge({notes: notes}.merge({form: "closed"}.merge({coin_name:transaction_params[:coin_attributes][:name]}))))))}  
                    f.html{render 'transactions/new' } 
                end
            end
        end
    end

    def show
        not_valid_transaction("view") if !authenticate(@transaction)

        respond_to do |f|
            f.html { render :show }
            f.json { render json: @transaction }
        end

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

            #recalculate quantity 
            @transaction.quantity = @transaction.money_in / @transaction.price_per_coin

            copyTransaction = Transaction.find_by(id: params[:id])
            
            inverseTransaction = Transaction.new(coin_id: copyTransaction.coin.id, money_in: (-1 * copyTransaction.money_in), price_per_coin: (0 * copyTransaction.price_per_coin), quantity: (-1 * copyTransaction.quantity))
            #update wallet with INVERSE of original (unedited) transaction to zero it out, then update wallet with typed in values 
            
            inverseCoin = Coin.find_by(id: inverseTransaction.coin_id)
            inverseName = inverseCoin.name
            wallet_to_take_away_from = current_user.wallets.find_by(name: inverseName); 
           
            wallet_to_take_away_from.update_wallet_with(inverseTransaction)
            wallet_to_update = current_user.wallets.find_by(name: @transaction.coin.name)
            wallet_to_update.update_wallet_with(@transaction)

            #-- disable callbacks
            # For an update to transaction, we have to deal with 'inverse' transactions when transactions#edit is called.
            # so normal callbacks (these assume creation of new transaction) will not be beneficial these cases
            Transaction.skip_callback(:save, :after, :tell_user)
            Transaction.skip_callback(:save, :after, :tell_wallet)
            Transaction.skip_callback(:save, :before, :calculate_quantity)
                    @transaction.save
            #-- re-enable callbacks
            Transaction.set_callback(:save, :after, :tell_user)
            Transaction.set_callback(:save, :after, :tell_wallet)
            Transaction.set_callback(:save, :before, :calculate_quantity)

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

        #if user has no other transactions with coin_id, delete AND wallet is not Ethereum, Bitcoin, Bitcoin Cash or Litecoin then delete wallet
        if current_user.transactions.find_by(coin_id: coin_id).nil? && wallet.name != "Ethereum" && wallet.name != "Bitcoin Cash" && wallet.name != "Bitcoin" && wallet.name != "Litecoin"
            wallet.destroy 
        end
        
        redirect_to user_transactions_path(current_user), notice: "Transaction has been deleted!"
    end

    private

    def find_tx
        @transaction = Transaction.find_by(id: params[:id])
    end

    def transaction_params
        params.require(:transaction).permit(:money_in, :price_per_coin, :coin_id, :comment, coin_attributes: [:name, :last_value, :id], note_attributes:[comments:[]]) 
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