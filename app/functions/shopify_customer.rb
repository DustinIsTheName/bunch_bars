class ShopifyCustomer

  def self.add_tag_to_customer(order)
    charity_type = order.note_attributes.select{|a| a.name == "CharityType"}.first

    if charity_type
      tag_list = order.customer.tags.split(',').map{|t| t.strip}

      tag_list = tag_list - ["Supporting - Kids", "Supporting - LGBTQ+ ", "Supporting - Women", "Choose for Me!"]

      tag_list << charity_type.value.strip

      order.customer.tags = tag_list

      order.customer.save
      puts Colorize.green "Saved customer"
    else
      puts Colorize.cyan "No charity tag"
    end
  end

end