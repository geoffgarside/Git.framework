require 'zlib'

class Bacon::Context
  def treeDataForSha(sha)
    file = "#{simple_repository.root}/.git/objects/%s/%s" % [sha[0,2], sha[2..-1]]
    Zlib::Inflate.inflate(File.read(file)).split("\x00", 2)[1].to_data
  end
  def treeForSha(sha)
    d = treeDataForSha(sha)
    GITTree.treeFromData(d, sha1:GITObjectHash.objectHashWithString(sha), repo:@repo, error:@err)
  end
end

describe 'GITTree' do
  before do
    @err = Pointer.new(:object)
    @repo = simple_repository.git_repo
    @tree = treeForSha('227c6c88ba35e67a1341a068c07d1c1639d6582e')
  end

  should 'not be nil' do
    @tree.should.not.be.nil
  end
  should 'not have an error' do
    @err[0].should.be.nil
  end
  should 'belong to repo' do
    @tree.repo.should == @repo
  end
  should 'have items' do
    @tree.items.should.not.be.empty
  end
  should 'have 2 items' do
    @tree.items.count.should == 2
  end

  describe 'items[0]' do
    before do
      @item = @tree.items[0]
    end
    should 'not be nil' do
      @item.should.not.be.nil
    end
    should 'belong to a tree' do
      @item.parent.should == @tree
    end
    should 'have mode' do
      @item.mode.should == 0x100644
    end
    should 'have name' do
      @item.name.should == '.gitignore'
    end
    should 'have sha1' do
      @item.sha1.unpackedString.should == 'afc72b2679ebc4d72b08ffe66d1adfb556d96f79'
    end
  end

  describe 'items[1]' do
    before do
      @item = @tree.items[1]
    end
    should 'not be nil' do
      @item.should.not.be.nil
    end
    should 'belong to a tree' do
      @item.parent.should == @tree
    end
    should 'have mode' do
      @item.mode.should == 0x100644
    end
    should 'have name' do
      @item.name.should == 'testfile.txt'
    end
    should 'have sha1' do
      @item.sha1.unpackedString.should == 'bd94b5ea8ab503e4e7676ab4668f5f1ec1f523ea'
    end
  end

  describe '-rawContent' do
    before do
      @data = treeDataForSha(@tree.sha1.unpackedString)
    end
    should 'return data in the correct format' do
      @tree.rawContent.should === @data
    end
  end
end
