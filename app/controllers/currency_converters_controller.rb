require 'net/http'
require 'uri'

class CurrencyConvertersController < ApplicationController
	skip_before_action :verify_authenticity_token

	def index
  
  end

	def convert_currency
	  source_currency = params[:source_currency]
	  destination_currency = params[:destination_currency]
	  amount = params[:amount].to_f
	  @api_key = ENV["API_KEY"]

	  url = URI("https://free.currconv.com/api/v7/convert?q=#{source_currency}_#{destination_currency}&compact=ultra&apiKey=#{@api_key}")

	  https = Net::HTTP.new(url.host, url.port)
	  https.use_ssl = true

	  request = Net::HTTP::Get.new(url)

	  response = https.request(request)

	  if response.code == '200'
	    data = JSON.parse(response.body)
	    rate = data["#{source_currency}_#{destination_currency}"]

	    if rate
	      converted_amount = amount * rate
	      @converted_amount = "#{converted_amount.round(2)} #{destination_currency}"
	    else
	      @error_message = "Exchange rate not available for #{source_currency} to #{destination_currency}"
	    end
	  else
	    @error_message = "Error: Unable to fetch exchange rate. HTTP #{response.code}"
	  end

	  if @converted_amount
	    flash[:notice] = @converted_amount
	  else
	    flash[:alert] = @error_message
	  end

	  redirect_to root_path
	rescue => e
	  flash[:alert] = "Error: #{e.message}"
	  redirect_to root_path
	end
end
