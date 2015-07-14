class EventsController < ApplicationController
  before_filter :set_page_info

  def set_page_info
    @menus[:system][:active] = "active"
  end

  def show
    @event = Event.find(params[:id])   

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events
  # GET /events.json
  def new
    @event = Event.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @event = Event.find(params[:id])   
  end

  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to events_path, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def change_date
    @event = Event.find(params[:id])
    
    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to events_path, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @event = Event.new(params[:event])
    respond_to do |format|
      if @event.save
        format.html { redirect_to events_path, notice: 'your event was saved.' }
          format.json { head :no_content }
      else
        render json: {msg: 'error: something go wrong.' }, status: 500
      end
    end
  end

  def index
    @events = Event.between(params['start'], params['end']) if (params['start'] && params['end']) 
    p @events 
    respond_to do |format| 
      format.html
      format.json { render :json => @events } 
    end
  end

end
