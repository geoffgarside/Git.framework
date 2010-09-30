describe 'GITTreeItem' do
  before do
    @sha1 = GITObjectHash.objectHashWithString('afc72b2679ebc4d72b08ffe66d1adfb556d96f79')
    @tree = GITTree.alloc.init
    @treeItem = GITTreeItem.itemInTree(@tree, withMode:0x100644, name:".gitignore", sha1:@sha1)
  end
  describe '-hash' do
    should 'be equal to @sha1.hash' do
      @treeItem.hash.should == @sha1.hash
    end
  end
  describe '-isEqual:' do
    before do
      err = Pointer.new(:object)
      repo = simple_repository.git_repo
      @sha2 = GITObjectHash.objectHashWithString('a2d0bba4b0d4f9bf0168dd68d1588bde05aa3e5b')
      @blob = repo.objectWithSha1(@sha2, error:err)

      @treeItem2 = GITTreeItem.itemInTree(@tree, withMode:0x100644, name:"file.txt", sha1:@sha2)
    end
    should 'be equal to itself' do
      @treeItem.isEqual(@treeItem).should.be.true
    end
    should 'not be equal to object with different sha1' do
      @treeItem.isEqual(@treeItem2).should.be.false
    end
    should 'be equal to object with matching sha1' do
      @treeItem2.isEqual(@blob).should.be.true
    end
  end
end
