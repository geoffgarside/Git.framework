describe 'GITDateTime' do
  describe '+dateTimeWithDate:' do
    before do
      @date = NSDate.date
      @zone = NSTimeZone.defaultTimeZone
      @dateTime = GITDateTime.dateTimeWithDate(@date)
    end
    should 'not be nil' do
      @dateTime.should.not.be.nil
    end
    should 'have date' do
      @dateTime.date.should === @date
    end
    should 'have time zone' do
      @dateTime.timeZone.should === @zone
    end
  end
  describe '+dateTimeWithDate:timeZone:' do
    before do
      @date = NSDate.date
      @zone = NSTimeZone.timeZoneWithAbbreviation("GMT")
      @dateTime = GITDateTime.dateTimeWithDate(@date, timeZone:@zone)
    end
    should 'not be nil' do
      @dateTime.should.not.be.nil
    end
    should 'have date' do
      @dateTime.date.should === @date
    end
    should 'have time zone' do
      @dateTime.timeZone.should === @zone
    end
  end
  describe '+dateTimeWithTimestamp:timeZoneOffset:' do
    before do
      @date = NSDate.date
      @zone = NSTimeZone.timeZoneWithAbbreviation("GMT")
      @dateTime = GITDateTime.dateTimeWithTimestamp(@date.timeIntervalSince1970, timeZoneOffset:@zone.offsetString)
    end
    should 'not be nil' do
      @dateTime.should.not.be.nil
    end
    should 'have date' do
      # For some as yet undetermined reason NSDate -isEqualToDate: fails with this
      # visual inspection of printed values of these dates seems to suggest they're
      # equal but we have to ditch the sub-second precision of the NSTimeInterval.
      @dateTime.date.timeIntervalSinceReferenceDate.to_i.should == @date.timeIntervalSinceReferenceDate.to_i
    end
    should 'have time zone' do
      @dateTime.timeZone.should === @zone
    end
  end
  describe '-description' do
    before do
      @date = NSDate.dateWithTimeIntervalSince1970(444123000)
      @zone = NSTimeZone.timeZoneWithAbbreviation("GMT")
      @dateTime = GITDateTime.dateTimeWithDate(@date, timeZone:@zone)
    end
    should 'format the date and timezone' do
      @dateTime.description.should == "444123000 +0000"
    end
  end
  describe "-stringWithFormat:" do
    before do
      @date = NSDate.dateWithTimeIntervalSince1970(444123000)
      @zone = NSTimeZone.timeZoneWithAbbreviation("GMT")
      @dateTime = GITDateTime.dateTimeWithDate(@date, timeZone:@zone)
      @string = @dateTime.stringWithFormat("E MMM dd, yyyy 'at' HH:mm:ss ZZZ")
    end
    should "format the date and timezone" do
      @string.should == "Sat Jan 28, 1984 at 07:30:00 +0000"
    end
  end
  describe "-compare:" do
    before do
      @date1 = NSDate.dateWithTimeIntervalSince1970(444123000)
      @date2 = NSDate.dateWithTimeIntervalSince1970(444126600)  # @date1 + 3600 seconds
      @zone1 = NSTimeZone.timeZoneWithAbbreviation("EST")
      @zone2 = NSTimeZone.timeZoneWithAbbreviation("CST")

      @dateTime = GITDateTime.dateTimeWithDate(@date1, timeZone:@zone1)
    end
    should 'be the same with date and zone shifted by one hour' do
      dt = GITDateTime.dateTimeWithDate(@date2, timeZone:@zone2)
      @dateTime.compare(dt).should == NSOrderedSame
    end
    should 'be ascending with date shifted by one hour' do
      dt = GITDateTime.dateTimeWithDate(@date2, timeZone:@zone1)
      @dateTime.compare(dt).should == NSOrderedAscending
    end
    should 'be descending with zone shifted back one hour' do
      dt = GITDateTime.dateTimeWithDate(@date1, timeZone:@zone2)
      @dateTime.compare(dt).should == NSOrderedDescending
    end
  end
end
