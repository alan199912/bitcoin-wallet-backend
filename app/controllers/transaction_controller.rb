require 'json'
require 'rest-client'

class TransactionController < ApplicationController

    def index
        transactions = Transaction.order(created_at: :desc)
        transactionList = []
        for transaction in transactions do
            user = User.find(params[:id])
            if transaction.user === user.id
                userData = user
                transactionList.push(transaction)
            end
        end

        transactionData = {
            user: userData,
            transaction: transactionList
        }
        render json: {
            status: "Success",
            data: transactionData,
        }, status: :ok
    end
    
    def create
        transaction = Transaction.new(transaction_params_usd)
        puts "TRANSACTION #{transaction.usd}"
        user = User.find(transaction.user)
        puts "USER #{user.usd}"
        if user.usd < transaction.usd
            return render json: {
                status: "Warning",
                message: "You dont have the money necesary to complete transaction"
            }, status: :ok
        end
        user.usd = user.usd - transaction.usd

        bitcoin = currentPriceBitcoin
        puts "BITCOIN #{bitcoin["rate_float"]}"
        transaction.btc = (transaction.usd / bitcoin["rate_float"])
        
        user.btc = user.btc + transaction.btc
        user.save

        if transaction.save
            return render json: {
                status: "Success",
                data: transaction
            }, status: :ok
        else
            return render json: {
                status: "Fail",
                data: transaction.errors
            }, status: :unprocessable_entity
        end
    end

    def show
        transaction = Transaction.find(params[:id])
            user = User.find(transaction.user)
            if transaction.user === user.id
                userData = user
            end
        transactionData = {
            user: userData,
            transaction: transaction
        }
        render json: {
            status: "Success",
            data: transactionData,
        }, status: :ok
    end

    private
        def transaction_params_usd
            params.permit(:purchase_currency, :usd, :exchangeRate, :user)
        end

    private
        def currentPriceBitcoin
            baseUrl = 'https://api.coindesk.com/v1/bpi/currentprice.json'
            response = RestClient.get baseUrl
            result = JSON.parse response.to_str
            bitcoin = result["bpi"]["USD"]
            return bitcoin
        end

end

# {
#     "purchase_currency": "",
#     "btc": "",
#     "usd": "",
#     "type": "",
#     "user_id": ""
# }