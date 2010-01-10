describe 'GITActor' do
  describe '+actor' do
    before do
      @actor = GITActor.actor
    end

    should 'not be nil' do
      @actor.should.not.be.nil
    end
    should 'have name "User"' do
      @actor.name.should == 'User'
    end
    should 'have email based on $USER and $HOST' do
      host = NSProcessInfo.processInfo.hostName
      @actor.email.should == "#{ENV['USER']}@#{host}"
    end
  end
  describe '+actorWithName:' do
    before do
      @actor = GITActor.actorWithName("Randy Waterhouse")
    end

    should 'not be nil' do
      @actor.should.not.be.nil
    end
    should 'have name "Randy Waterhouse"' do
      @actor.name.should == 'Randy Waterhouse'
    end
    should 'have email based on $USER and $HOST' do
      host = NSProcessInfo.processInfo.hostName
      @actor.email.should == "#{ENV['USER']}@#{host}"
    end
  end
  describe '+actorWithName:email:' do
    before do
      @actor = GITActor.actorWithName("Randy Waterhouse", email:"randy.waterhouse@epiphyte.net")
    end

    should 'not be nil' do
      @actor.should.not.be.nil
    end
    should 'have name "Randy Waterhouse"' do
      @actor.name.should == 'Randy Waterhouse'
    end
    should 'have email "randy.waterhouse@epiphyte.net"' do
      @actor.email.should == "randy.waterhouse@epiphyte.net"
    end
  end
  describe '-description' do
    before do
      @actor = GITActor.actorWithName("Randy Waterhouse", email:"randy.waterhouse@epiphyte.net")
    end
    should 'format name and email' do
      @actor.description.should == "Randy Waterhouse <randy.waterhouse@epiphyte.net>"
    end
  end
end
