rails g serializer transaction
    class TransactionSerializer < ActiveModel::Serializer
		attributes :id, :name...whatever
        has_many: :notes
    end

	class TransactionController < ApplicationController
		def show
			@transaction = Transaction.find(params[:id])
			respond_to do |f|
				f.html { render :show }
				f.json { render json: @transaction }
			end
		end
    end


rails g serializer note
//notes may need a show view to render its own JSON, so that when transaction json is rendered it includes the notes JSON

    class NoteSerializer < ActiveModel::Serializer
		attributes :id whatever
        belongs_to :transaction
    end