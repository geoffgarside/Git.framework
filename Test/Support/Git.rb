require 'fileutils'
require 'time'

module Git
  module Helpers
    def simple_repository
      @simple_repository ||= repository "Simple" do
        commit "Initial commit" do
          write ".gitignore",   ".fseventsd/\n"
          write "testfile.txt", "Git Rocks\n"
        end
        commit "Update testfile.txt" do
          write "testfile.txt", "Git Rocks, and rolls!!!\n"
        end
      end
    end


    def repository(root, *args, &blk)
      root = File.expand_path(root, tmp_dir)
      Repository.build(root, *args, &blk)
    end

    def tmp_dir
      File.expand_path("../../Tmp", __FILE__)
    end
  end

  class Repository
    def self.build(root, *finalize_with, &blk)
      repo = new(root)
      Dir.chdir root do
        repo.instance_eval(&blk)
      end

      finalize_with.each do |method_name|
        repo.send method_name
      end

      repo
    end

    attr_reader :commits

    def initialize(root)
      if File.exist?(root) && !File.directory?(root)
        raise "`#{root}` must be a directory"
      end

      @root    = root
      @commits = []

      if File.exist?(root)
        FileUtils.rm_rf(root)
      end
      FileUtils.mkdir_p(root)

      git "init"
    end

    def git_repo
      GITRepo.repoWithRoot(@root)
    end

    def commit(msg, &blk)
      c = Commit.build(self, &blk)
      c.commit!(msg)
      @commits << c
    end

    def repack
      git "repack -q"
    end

    def git(cmd)
      Dir.chdir(@root) { %x'git #{cmd}' }
    end

    def pack_files_with_index
      Dir["#{@root}/.git/objects/pack/pack-*.pack"].map do |pack|
        [ pack, pack.sub(/pack$/, 'idx') ]
      end
    end

    def pack_files
      pack_files_with_index.map { |pack, index| pack }
    end

    def delete_pack_index_files!
      pack_files_with_index.each do |pack, idx|
        FileUtils.rm_rf(idx)
      end
    end
  end

  class Commit
    attr_reader :sha, :author_name, :author_email, :author_date, :committer_name,
                :committer_email, :committer_date

    def self.build(repo, &blk)
      c = new(repo)
      c.instance_eval(&blk)
      c
    end

    def initialize(repo)
      @repo = repo
    end

    def write(file, content)
      File.write(file, content)
      @repo.git "add #{file}"
    end

    def commit!(msg)
      git "commit -qm '#{msg}'"

      # sha (%H)   author_name (%an)   author_email    timestamp
      format = %w(%H %an %ae %aD %cn %ce %cD).join("%n")
      i = git("log -1 --pretty='format:#{format}'").strip.split("\n")
      @sha             = i[0]
      @author_name     = i[1]
      @author_email    = i[2]
      @author_date     = Time.rfc2822(i[3])
      @committer_name  = i[4]
      @committer_email = i[5]
      @committer_date  = i[6]
    end

  private

    def git(*args)
      @repo.git(*args)
    end

  end
end