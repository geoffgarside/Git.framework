require File.dirname(__FILE__) +'/../TestHelper.rb'

class GITRepoTests < Test::Unit::TestCase
  context "GITRepo" do
    context "+repo" do
      setup do
        Dir.chdir(TEST_REPO) do
          @repo = GITRepo.repo
        end
      end
      should "open repo in current directory" do
        assert @repo.root == TEST_REPO + "/.git", "#{@repo.root} did not match #{TEST_REPO}/.git"
      end
    end
    # context "+repoWithRoot:" do
    #   context "with valid repo" do
    #     setup do
    #       @repo = GITRepo.repoWithRoot(TEST_REPO)
    #     end
    #     should "open repo at #{TEST_REPO}" do
    #       assert @repo.root == TEST_REPO
    #     end
    #   end
    #   context "with invalid repo" do
    #     setup do
    #       @repo = GITRepo.repoWithRoot('/tmp/nonexistent')
    #     end
    #     should "return nil" do
    #       assert_nil @repo
    #     end
    #   end
    # end
    # context "+repoWithRoot:error:" do
    #   setup do
    #     @error = Pointer.new(:object)
    #   end
    #   context "with valid repo" do
    #     setup do
    #       @repo = GITRepo.repoWithRoot('', error:@error)
    #     end
    #     should "open repo at " do
    #       assert @repo.root = ''
    #     end
    #     should "not raise an error" do
    #       assert_nil @error[0]
    #     end
    #   end
    #   context "with nonexistent path" do
    #     setup do
    #       @repo = GITRepo.repoWithRoot('/tmp/git-repo', error:@error)
    #     end
    #     should "return nil" do
    #       assert_nil @repo
    #     end
    #     should "raise an error" do
    #       assert_not_nil @error[0]
    #     end
    #     should "raise a path error" do
    #       assert @error.code == GITRepoErrorRootDoesNotExist
    #     end
    #   end
    #   context "with disallowed path (permissions)" do
    #     setup do
    #       @repo = GITRepo.repoWithRoot('', error:@error)
    #     end
    #     should "return nil" do
    #       assert_nil @repo
    #     end
    #     should "raise an error" do
    #       assert_not_nil @error[0]
    #     end
    #     should "raise a permission error" do
    #       assert @error.code == GITRepoErrorRootNotAccessible
    #     end
    #   end
    #   context "with no permission to path" do
    #     setup do
    #       @repo = GITRepo.repoWithRoot('', error:@error)
    #     end
    #     should "return nil" do
    #       assert_nil @repo
    #     end
    #     should "raise an error" do
    #       assert_not_nil @error[0]
    #     end
    #     should "raise a permission error" do
    #       assert @error.code == GITRepoErrorRootInsane
    #     end
    #   end
    # end
  end
end
