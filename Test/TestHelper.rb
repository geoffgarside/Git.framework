def default_repository
  GITRepo.repoWithRoot(TEST_REPO)
end

GITRepoErrorRootDoesNotExist    = -1
GITRepoErrorRootNotAccessible   = -2
GITRepoErrorRootInsane          = -3
GITRefResolverErrorRefNotFound  = -4

class GITRef
  def link?
    self.isLink == 1
  end
end

# Useful string encodings
NSUTF8StringEncoding = 4

class NSObject
  def ==(rhs)
    self.isEqual(rhs) ? true : false
  end
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
