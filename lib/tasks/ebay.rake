namespace :ebay do
  desc "Ebay Integration"
  task :add_item, [:item_id, :item_revision_id] => :environment do |t, args|
    @item = Item.find(args.item_id)
    @item_revision = ItemRevision.find(args.item_revision_id)
    sku =  @item.item_part_no
    title = @item_revision.item_name
    description = @item_revision.item_description
    start_price = @item.weighted_cost
    quantity = @item.stock(ItemRevision.find(@item_revision.id))
    if description == ''
      description = 'Test Description'
    end
    start_price = start_price.to_d.to_s
     @item_channel =  ItemChannel.where(:item_revision_id => args.item_revision_id, :channel => "eBay").first
    require 'eBayAPI'
    require 'eBay'
    # load('myCredentials.rb')
    eBay = EBay::API.new(Rails.application.config.ebay_auth_token,Rails.application.config.ebay_dev_id,Rails.application.config.app_id,Rails.application.config.cert_id, :sandbox => true)
    unless defined? @item_channel.channel_item_id
      # Notice how we nest hashes to mimic the XML structure of an AddItem request
      resp = ''
     begin
      resp = eBay.AddItem(:Item => EBay.Item(:PrimaryCategory => EBay.Category(:CategoryID => 111422),
                                              :SKU => sku,
                                              :Title => title,
                                              :ConditionID => '1000',
                                              :Description => description,
                                              :Location => 'On Earth',
                                              :StartPrice => start_price,
                                              :Quantity => quantity,
                                              :ListingDuration => "Days_7",
                                              :Country => "US",
                                              :Currency => "USD",
                                              :ShippingDetails => EBay.ShippingDetails(
                                                                  :ShippingServiceOptions => [
                                                                    EBay.ShippingServiceOptions(
                                                                      :ShippingService => ShippingServiceCodeType::USPSPriority,
                                                                      :ShippingServiceCost => '0.0',
                                                                      :ShippingServiceAdditionalCost => '0.0'),
                                                                    EBay.ShippingServiceOptions(
                                                                      :ShippingService => ShippingServiceCodeType::USPSPriorityFlatRateBox,
                                                                      :ShippingServiceCost => '7.0',
                                                                      :ShippingServiceAdditionalCost => '0.0')]),
                                                                :ShippingTermsInDescription => false,
                                                                :ShipToLocations => "US",
                                              :DispatchTimeMax => '3',
                                              :ListingType => 'FixedPriceItem',
                                              :PaymentMethods => ["AmEx"],
                                              :ReturnPolicy => EBay.ReturnPolicy(
                                                                :Description => "No return policy",
                                                                :ReturnsAccepted => "without damage",
                                                                :ReturnsAcceptedOption => "ReturnsAccepted"
                                                               )
                                              ))
          if defined? resp.itemID
           puts "New Item #" + resp.itemID + " added."
          end
          ItemChannel.create(:item_revision_id => args.item_revision_id, :channel => "eBay", :channel_item_id => resp.itemID)
        rescue Exception => msg
          result = msg.to_s
          puts result
          next
        end
      else
        begin
          resp = eBay.ReviseItem(:Item =>EBay.Item(
                                            :StartPrice => start_price,
                                            :Quantity => quantity,
                                            :ItemID => @item_channel.channel_item_id,
                                            ))

          if defined? resp.itemID
            puts resp.itemID + " updated"
          end
        rescue Exception => msg
          result = msg.to_s
          puts result
          next
        end
      end
      result
  end

  task :add_item_multiple, [:item_revision_ids] => :environment do |t, args|
    addItemReqContainerArray = Array.new
    itemRevIds = args.item_revision_ids.split(" ")
    if itemRevIds.length > 0 then
      i = 0
      sku = Array.new
      title = Array.new
      description = Array.new
      start_price = Array.new
      quantity = Array.new
      itemRevIds.each do |item_revision_id|
        @item_revision = ItemRevision.find(item_revision_id)
        item_id = @item_revision.item_id
        @item = Item.find(item_id)
        sku[i] =  @item.item_part_no
        title[i] = @item_revision.item_name
        description[i] = @item_revision.item_description
        start_price[i] = @item.weighted_cost
        quantity[i] = @item.stock(ItemRevision.find(@item_revision.id))
        if description[i] == ''
          description[i] = 'Test Description'
        end
        start_price[i] = start_price[i].to_d.to_s
        i = i + 1
      end
      i = 0
      require 'eBayAPI'
      require 'eBay'
      itemRevIds.each do |item_revision_id|
      addItemReqContainerArray.push(EBay.AddItemRequestContainer(:Item => EBay.Item(:PrimaryCategory => EBay.Category(:CategoryID => 111422),
                                              :Title => title[i],
                                              :ConditionID => '1000',
                                              :Description => description[i],
                                              :Location => 'On Earth',
                                              :StartPrice => start_price[i],
                                              :Quantity => quantity[i],
                                              :ListingDuration => "Days_7",
                                              :Country => "US",
                                              :Currency => "USD",
                                              :Site => "US",
                                              :ShippingDetails => EBay.ShippingDetails(
                                                                  :ShippingServiceOptions => [
                                                                    EBay.ShippingServiceOptions(
                                                                      :ShippingService => ShippingServiceCodeType::USPSPriority,
                                                                      :ShippingServiceCost => '0.0',
                                                                      :ShippingServiceAdditionalCost => '0.0'),
                                                                    EBay.ShippingServiceOptions(
                                                                      :ShippingService => ShippingServiceCodeType::USPSPriorityFlatRateBox,
                                                                      :ShippingServiceCost => '7.0',
                                                                      :ShippingServiceAdditionalCost => '0.0')]),
                                                                :ShippingTermsInDescription => false,
                                                                :ShipToLocations => "US",
                                              :DispatchTimeMax => '3',
                                              :ListingType => 'FixedPriceItem',
                                              :PaymentMethods => ["AmEx"],
                                              :ReturnPolicy => EBay.ReturnPolicy(
                                                                :Description => "No return policy",
                                                                :ReturnsAccepted => "without damage",
                                                                :ReturnsAcceptedOption => "ReturnsAccepted"
                                                               )


                                            ),
                                            :MessageID => "test" + i.to_s + "0"
                                          ))
        i = i + 1
      end
    end

    # load Credentials

    eBay = EBay::API.new(Rails.application.config.ebay_auth_token,Rails.application.config.ebay_dev_id,Rails.application.config.app_id,Rails.application.config.cert_id, :sandbox => true)
    begin
      resp = eBay.AddItems(:AddItemRequestContainer => addItemReqContainerArray)
      res = Hash.new
      i = 0
      if resp.addItemResponseContainer.kind_of?(Array)
        resp.addItemResponseContainer.each do |response_container|
          res[itemRevIds[i]] = response_container.itemID.present? ? response_container.itemID : "Errors in Input Data"
          i = i + 1
        end
      else
        res[itemRevIds[i]] = resp.addItemResponseContainer.itemID.present? ? resp.addItemResponseContainer.itemID : "Errors in Input Data"
      end
      puts res.to_json
    rescue Exception => msg
      result = msg.to_s
      puts result.to_json
      next
    end
  end

  task :getItemsList => :environment do
    require 'eBayAPI'
    require 'eBay'
    eBay = EBay::API.new(Rails.application.config.ebay_auth_token,Rails.application.config.ebay_dev_id,Rails.application.config.app_id,Rails.application.config.cert_id, :sandbox => true)
    begin
      resp = eBay.GetSellerList(:StartTimeFrom => '2016-12-01',
                                :StartTimeTo => '2017-03-01',
                                :DetailLevel => DetailLevelCodeType::ItemReturnAttributes,
                                :Pagination => EBay.Pagination(:EntriesPerPage => 10,
                                                               :PageNumber => 18),
                                :GranularityLevel => GranularityLevelCodeType::Fine
                                )
                                # :UserID => "testuser_rehna"   )
      resp.itemArray.each do |field, val|
        puts "Item ID: " + field.itemID.to_s
        puts "Quantity:"  + field.quantity.to_s
        puts "Title:" + field.title.to_s
        puts "Price:" + field.startPrice.to_s
      end
    rescue Exception => msg
      puts msg.to_json
    end
  end
end
