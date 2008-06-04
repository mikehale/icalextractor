require 'test/unit'

require File.join(File.dirname(__FILE__), '..', 'lib', 'go.rb')

class TestGo < Test::Unit::TestCase
  
  # def test_to_ical
  #   assert_equal 'nil', Month.new(File.join(File.dirname(__FILE__), 'june2008.html')).to_ical
  # end
  
  def test_lines
    first_week = Month.new(File.join(File.dirname(__FILE__), 'june2008.html')).weeks.first
    assert_equal 1, first_week.days[0].number
    assert_equal 2, first_week.days[1].number
    assert_equal 3, first_week.days[2].number
    assert_equal 4, first_week.days[3].number
    assert_equal 5, first_week.days[4].number
    assert_equal 6, first_week.days[5].number
    assert_equal 7, first_week.days[6].number

    assert_equal "LW SM MJ open,SM", first_week.days[0].lines[0]
    assert_equal "EH SM JL 12-9:30", first_week.days[0].lines[1]
    assert_equal "RM 1-9:30 EL 2-9:30", first_week.days[0].lines[2]
    assert_equal "JS 1-9:30 AH", first_week.days[0].lines[3]
    assert_equal "SB SM", first_week.days[0].lines[4]
    assert_equal "Ritter 9-7:30 (O-MJ C-KW)", first_week.days[0].lines[6]
    assert_equal "7:30 Staff Meeting (ALL)", first_week.days[0].lines[7]
    
    assert_equal "LW", first_week.days[0].events[0].who
    assert_equal "staff meeting", first_week.days[0].events[0].what
    assert_equal nil, first_week.days[0].events[0].time

    assert_equal "MJ", first_week.days[0].events[1].who
    assert_equal "open,staff meeting", first_week.days[0].events[1].what
    assert_equal nil, first_week.days[0].events[1].time

    assert_equal "EH", first_week.days[0].events[2].who
    assert_equal "staff meeting", first_week.days[0].events[2].what
    assert_equal nil, first_week.days[0].events[2].time

    assert_equal "JL", first_week.days[0].events[3].who
    assert_equal nil, first_week.days[0].events[3].what
    assert_equal "12-9:30", first_week.days[0].events[3].time
    
    # pp first_week.days[0].events
    pp first_week.days[0].scheduled_hours[0].summary
    first_week.days[0].scheduled_hours
  end
  
  # def test_fail
  #   event = Go.new(File.join(File.dirname(__FILE__), 'june2008.html')).events.first
  #   assert_equal "EH", event.who
  #   assert_equal "Staff Meeting", event.title
  #   assert_equal "7:30", event.time
  # end
end
