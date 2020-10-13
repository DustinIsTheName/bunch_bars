class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_headers

  def order
    puts params

    begin
      order = ShopifyAPI::Order.find params["id"]
      ShopifyCustomer.add_tag_to_customer order
    rescue => e
      puts Colorize.red('Error in webhook')
      puts e
    end

    render json: nil
  end

  private

    def set_headers
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Request-Method'] = '*'
    end

    def verify_webhook(data, hmac_header)
      digest  = OpenSSL::Digest.new('sha256')
      calculated_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, ENV["WEBHOOK_SECRET"], data)).strip
      if calculated_hmac == hmac_header
        puts Colorize.green("Verified!")
      else
        puts Colorize.red("Invalid verification!")
      end
      calculated_hmac == hmac_header
    end

end