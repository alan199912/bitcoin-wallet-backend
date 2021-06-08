require 'json'
require 'rest-client'


class BitcoinController < ApplicationController
    def index
        bitcoin = currentPriceBitcoin
        render json: {
            status: "Success",
            data: bitcoin
        }, status: :ok
    end

    def create
        transaction = Transaction.new(transaction_params_btc)
        puts "TRANSACTION #{transaction.btc}"
        user = User.find(transaction.user)
        puts "USER #{user.btc}"
        if user.btc < transaction.btc
            return render json: {
                status: "Warning",
                message: "You dont have the money necesary to complete transaction"
            }, status: :ok
        end
        user.btc = user.btc - transaction.btc
        
        bitcoin = currentPriceBitcoin
        puts "BITCOIN #{bitcoin["rate_float"]}"
        transaction.usd = (bitcoin["rate_float"] * transaction.btc)
        
        user.usd = user.usd + transaction.usd
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

    private
        def transaction_params_btc
            params.permit(:purchase_currency, :btc, :exchangeRate, :user)
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
