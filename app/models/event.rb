# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  start_at    :datetime
#  end_at      :datetime
#  allDay      :string(255)
#  user_name   :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  repeats     :string(255)
#  description :text(65535)
#  user_id     :integer
#  frequency   :integer
#  parent_id   :integer
#

class Event < ActiveRecord::Base  
  belongs_to :user
  # scope :between, lambda {|start_time, end_time| {:conditions => ["? < starts_at and starts_at < ?", Event.format_date(start_time), Event.format_date(end_time)] }}
   validates_presence_of :title
   validates_presence_of :frequency,  :if => :present_repeats?, :message => "Please provide No. of Occurence"
   validate :date_interval

  def present_repeats?
    repeats.present?
  end
  def date_interval
    if start_at > end_at
      errors.add(:end_at,  "End At must be greater than Start At")
    end  
  end

  def create_similar_events()        
    case self.repeats
      when "Daily"
        i = 1
        ((self.frequency)-1).times do
          Event.create(:title => self.title, :start_at => self.start_at+i.day, :end_at => self.end_at+ i.day, :description => self.description, :repeats => self.repeats, :frequency => self.frequency, :parent_id => self.id)
          i = i + 1 
        end    
      when "Weekly" 
        i = 1
        ((self.frequency)-1).times do
          Event.create(:title => self.title, :start_at => self.start_at+i.weeks, :end_at => self.end_at+ i.weeks, :description => self.description, :repeats => self.repeats, :frequency => self.frequency, :parent_id => self.id)
          i = i + 1 
        end
      when "Monthly"
        i = 1
        ((self.frequency)-1).times do
          Event.create(:title => self.title, :start_at => self.start_at+i.months, :end_at => self.end_at+ i.months, :description => self.description, :repeats => self.repeats, :frequency => self.frequency, :parent_id => self.id)
          i = i + 1 
        end
      when "Yearly"
        i = 1
        ((self.frequency)-1).times do
          Event.create(:title => self.title, :start_at => self.start_at+i.years, :end_at => self.end_at+ i.years, :description => self.description, :repeats => self.repeats, :frequency => self.frequency, :parent_id => self.id)
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
