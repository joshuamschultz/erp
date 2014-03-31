class PayablePoShipmentsController < ApplicationController
  
  def destroy
    @shipment = PayablePoShipment.find(params[:id])
    @shipment.destroy

    respond_to do |format|
      format.html { redirect_to @shipment.payable }
      format.json { head :no_content }
    end
  end

end
