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
      puts "Not exist"

      # Notice how we nest hashes to mimic the XML structure of an AddItem request
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

        puts "New Item #" + resp.itemID + " added."
        puts "Exist"
        ItemChannel.create(:item_revision_id => args.item_revision_id, :channel => "eBay", :channel_item_id => resp.itemID)
      else

        resp = eBay.ReviseItem(:Item =>EBay.Item(
                                            :StartPrice => start_price,
                                            :Quantity => quantity,
                                            :ItemID => @item_channel.channel_item_id,
                                            ))
        puts "Item updated"
      end
  end

  task add_item_multiple: :environment do  ###Not yet completed
    require 'eBayAPI'
    require 'eBay'

    # load('myCredentials.rb')

    eBay = EBay::API.new(Rails.application.config.ebay_auth_token,Rails.application.config.ebay_dev_id,Rails.application.config.app_id,Rails.application.config.cert_id, :sandbox => true)

      # Notice how we nest hashes to mimic the XML structure of an AddItem request
      resp = eBay.AddItems(:AddItemRequestContainer => EBay.AddItemsRequest(:Item => EBay.Item(:PrimaryCategory => EBay.Category(:CategoryID => 57882),
                                             :Title => "Harry Potter and the Philosopher's Stone - III",
                                             :ConditionID => '1000',
                                             :Description => 'This is the first book in the Harry Potter series. In excellent condition!',
                                             :Location => 'On Earth',
                                             :StartPrice => '12.0',
                                             :Quantity => 1,
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
                                                              :ShipToLocations => "US",
                                             :DispatchTimeMax => '3',
                                             :ListingType => 'Chinese',
                                             :PaymentMethods => ["AmEx"],
                                             :ReturnPolicy => EBay.ReturnPolicy(
                                                              :Description => "No return policy",
                                                              :ReturnsAccepted => "without damage",
                                                              :ReturnsAcceptedOption => "ReturnsAccepted"
                                                             )
                                            )),
                            :AddItemRequestContainer => EBay.AddItemsRequest(:Item => EBay.Item(:PrimaryCategory => EBay.Category(:CategoryID => 57882),
                                             :Title => "Harry Potter and the Philosopher's Stone - IV",
                                             :ConditionID => '1000',
                                             :Description => 'This is the first book in the Harry Potter series. In excellent condition!',
                                             :Location => 'On Earth',
                                             :StartPrice => '12.0',
                                             :Quantity => 1,
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
                                                              :ShipToLocations => "US",
                                             :DispatchTimeMax => '3',
                                             :ListingType => 'Chinese',
                                             :PaymentMethods => ["AmEx"],
                                             :ReturnPolicy => EBay.ReturnPolicy(
                                                              :Description => "No return policy",
                                                              :ReturnsAccepted => "without damage",
                                                              :ReturnsAcceptedOption => "ReturnsAccepted"
                                                             )
                                            )
                                        )
                          )

  puts "New Item #" + resp.itemID + " added."
  resp
  end

end
