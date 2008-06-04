require 'rubygems'
require 'hpricot'
require 'icalendar'
require 'date'

class Month
  def initialize(file)
    @doc = open(file) { |f| Hpricot(f) }
    wierd_space = (@doc/"span.Apple-converted-space")
    wierd_space.before('<span> </span>')
    wierd_space.remove
  end
  
  def to_ical
    cal = Icalendar::Calendar.new
    cal.event do
      dtstart       Date.new(2005, 04, 29)
      dtend         Date.new(2005, 04, 28)
      summary     "Meeting with the man."
    end
    cal.to_ical
  end
  
  def weeks
    weeks = []
    rows = (@doc/"tr")
    rows.shift # day names
    rows.each {|week| weeks << Week.new(week)}
    weeks
  end
  
end

class Week
  def initialize(week)
    @week = week
  end
  
  def days
    days = []
    (@week/"td").each{|day| days << Day.new(day)}
    days
  end
end

class Day
  attr_reader :number
  
  def initialize(day)
    @day = day    
    @lines = (@day/"p")
    @number = @lines.shift.inner_text.to_i
  end
  
  def lines
    @lines.collect {|line| (line).inner_text.gsub(/ +/,' ') }
  end
  
  def scheduled_hours
    sh = (@day/"p.p5").collect {|e| e.inner_text }
    events = []
    sh.each{|e|
      matches = e.gsub('SM','staff meeting').scan(/([A-Z]{2,2}) ([^A-Z]+)/)
      matches.each{|m|
        event = Icalendar::Event.new
        event.start = DateTime.civil(2006, 6, 23, 8, 30)
        event.add_attendee m[0].strip
        event.summary = m[1].strip
        events << event
      }
    }
    events
  end
  
  def events
    events = []
    lines.each{|line|
      matches = line.gsub('SM','staff meeting').scan(/([A-Z]{2,2}) ([^A-Z]+)/)
      matches.each{|m|
        events << Event.new(m[0].strip, m[1].strip)
      }
    }
    events
  end
  
end

class Event
  attr_accessor :who, :time, :what
  
  def initialize(who, data)
    @who = who
    @data = data
  end
  
  def what
    @data unless @data =~ /.+-.+/
  end
  
  def time
    @data if @data =~ /.+-.+/
  end
end


if __FILE__ == $0
  puts Go.new(ARGV[0]).first
end