require 'fileutils'

module Git
  module Helpers
    def simple_repository
      @simple_repository ||= repository "Simple" do
        commit "Initial commit" do
          write "testfile.txt", "Git Rocks"
        end
        commit "Update testfile.txt" do
          write "testfile.txt", "Git Rocks, and rolls!!!"
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

    def initialize(root)
      if File.exist?(root) && !File.directory?(root)
        raise "`#{root}` must be a directory"
      end

      @root = root
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
      @repo.git "commit -qm '#{msg}'"
    end
  end
end