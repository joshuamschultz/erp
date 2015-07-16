class Event < ActiveRecord::Base  
  belongs_to :user
  attr_accessible :title, :start_at, :end_at, :allDay, :description, :repeats, :user_id, :frequency
  # scope :between, lambda {|start_time, end_time| {:conditions => ["? < starts_at and starts_at < ?", Event.format_date(start_time), Event.format_date(end_time)] }}
  before_save :process_before_save

  def process_before_save
    start_at = self.start_at.utc
    end_at = self.end_at.utc
  end
  def create_similar_events()        
    case self.repeats
      when "Daily"
        i = 1
        ((self.frequency)-1).times do
          Event.create(:title => self.title, :start_at => self.start_at+i.day, :end_at => self.end_at+ i.day, :description => self.description, :repeats => self.repeats)
          i = i + 1 
        end    
      when "Weekly" 
        i = 1
        ((self.frequency)-1).times do
          Event.create(:title => self.title, :start_at => self.start_at+i.weeks, :end_at => self.end_at+ i.weeks, :description => self.description, :repeats => self.repeats)
          i = i + 1 
        end
      when "Monthly"
        i = 1
        ((self.frequency)-1).times do
          Event.create(:title => self.title, :start_at => self.start_at+i.months, :end_at => self.end_at+ i.months, :description => self.description, :repeats => self.repeats)
          i = i + 1 
        end
      when "Yearly"
        i = 1
        ((self.frequency)-1).times do
          Event.create(:title => self.title, :start_at => self.start_at+i.years, :end_at => self.end_at+ i.years, :description => self.description, :repeats => self.repeats)
          i = i + 1 
        end
    end
  
  end

  def self.between(start_time, end_time)
    where('start_at > :lo and start_at < :up',
      :lo => Event.format_date(start_time),
      :up => Event.format_date(end_time)
    )
  end

  def self.format_date(date_time)
   Time.at(date_time.to_i).to_formatted_s(:db)
  end

  def as_json(options = {})
    {
      :id => self.id,
      :title => self.title,
      :start => start_at.rfc822,
      :end => end_at.rfc822,
      :allDay => allDay,
      :user_name => self.user_name,
      :url => Rails.application.routes.url_helpers.events_path(id),
      :color => "green"
    }
  end

end
