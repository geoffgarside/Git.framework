require 'digest/sha1'

BLOB_CONTENTS = <<EOB
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin fermentum ipsum ut diam ultricies eget congue dui condimentum. Nullam sit amet porta nunc. Maecenas magna ipsum, bibendum eu sagittis ut, rutrum sed mauris. Sed venenatis augue in dolor ultricies vulputate. Cras faucibus, ante quis iaculis mattis, nibh justo accumsan purus, vitae placerat lorem velit a quam. Morbi elit nunc, adipiscing sit amet euismod non, varius suscipit leo. Aenean velit lacus, sodales a tincidunt eget, bibendum eu sem. Curabitur venenatis malesuada nisi, vel ornare justo auctor vitae. Nulla nisi nisi, interdum non sodales vel, sodales eu ante. Donec eleifend metus et tellus aliquet consequat. Nam laoreet odio ac dolor mollis id iaculis ante convallis. Morbi lobortis, dolor non tincidunt aliquam, nulla arcu commodo augue, sit amet molestie lectus odio sed lorem. In sapien diam, semper eu viverra non, lobortis ac nisi. Sed vehicula orci quis nibh rutrum accumsan varius et risus. Nullam vitae augue leo. Morbi interdum, neque eu porttitor molestie, augue tellus interdum eros, at iaculis massa enim eu urna. Sed at nibh tellus, at vestibulum magna. In hac habitasse platea dictumst.
EOB

describe 'GITBlob' do
  before do
    @sha = Digest::SHA1.hexdigest(BLOB_CONTENTS)
    @err = Pointer.new(:object)
    @repo = simple_repository.git_repo
    @data = BLOB_CONTENTS.dataUsingEncoding(NSUTF8StringEncoding)
    @blob = GITBlob.blobFromData(@data, sha1:GITObjectHash.objectHashWithString(@sha), repo:@repo, error:@err)
  end
  should 'not be nil' do
    @blob.should.not.be.nil
  end
  should 'not have an error' do
    @err[0].should.be.nil
  end
  should 'store the content' do
    @blob.content.should == @data
  end
  should 'hash the data' do
    @blob.sha1.unpackedString.should == @sha
  end
end
