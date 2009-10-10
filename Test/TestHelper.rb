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
