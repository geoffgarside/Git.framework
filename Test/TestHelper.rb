def default_repository
  GITRepo.repoWithRoot(TEST_REPO)
end

class NSData
  def ===(rhs)
    raise ArgumentError, "Must be kind of NSData" unless rhs.kind_of?(NSData)
    self.isEqualToData(rhs) ? true : false
  end
end

class NSString
  def ===(rhs)
    raise ArgumentError, "Must be kind of NSString" unless rhs.kind_of?(NSString)
    self.isEqualToString(rhs) ? true : false
  end
end
