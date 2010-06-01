require 'time'

Dir[File.expand_path("../Support/*.rb", __FILE__)].each do |support_file|
  require support_file
end

class Bacon::Context
  include Git::Helpers
end

def default_repository
  GITRepo.repoWithRoot(TEST_REPO)
end

class String
  def to_data
    return NSData.data unless length > 0

    bytes = self.bytes.to_a
    p = Pointer.new_with_type("char *", bytes.length)

    bytes.each_with_index do |char, i|
      p[i] = char
    end

    NSData.dataWithBytes(p, length:bytes.length)
  end
end

class Time
  def to_git
    GITDateTime.dateTimeWithTimestamp(to_i, timeZoneOffset:rfc2822.split(" ").last)
  end
end

class NSData
  def ===(rhs)
    raise ArgumentError, "Must be kind of NSData" unless rhs.kind_of?(NSData)
    self.isEqualToData(rhs) ? true : false
  end
end

class NSDate
  def ===(rhs)
    raise ArgumentError, "Must be kind of NSDate" unless rhs.kind_of?(NSDate)
    self.isEqualToDate(rhs) ? true : false
  end
end

class NSString
  def ===(rhs)
    raise ArgumentError, "Must be kind of NSString" unless rhs.kind_of?(NSString)
    self.isEqualToString(rhs) ? true : false
  end
end

class NSTimeZone
  def ===(rhs)
    raise ArgumentError, "Must be kind of NSTimeZone" unless rhs.kind_of?(NSTimeZone)
    self.isEqualToTimeZone(rhs) ? true : false
  end
end

class GITDateTime
  def to_time
    Time.parse(stringWithFormat("yyyy-MM-dd HH:mm:ss ZZZ"))
  end
end
