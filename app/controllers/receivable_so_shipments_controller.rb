class ReceivableSoShipmentsController < ApplicationController
  def destroy
    @shipment = ReceivableSoShipment.find(params[:id])
    @shipment.destroy

    respond_to do |format|
      format.html { redirect_to @shipment.receivable }
      format.json { head :no_content }
    end
  end
end
