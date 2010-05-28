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

    def graph_repository
      @graph_repository ||= repository "Graph" do
        commit "Graph First Commit" do
          write "file.txt", ""
        end
        commit "Graph Second Commit" do
          write "file.txt", "a\n"
        end

        branch "graph-branch1"

        commit "Graph Third Commit" do
          write "file.txt", "aa\n"
        end
        commit "Graph Fourth Commit" do
          write "file.txt", "aaa\n"
        end

        branch "graph-branch2"

        branch "graph-branch1" do
          commit "Graph Branch 1 First Commit" do
            write "file.txt", "a\nb1\n"
          end
          commit "Graph Branch 1 Second Commit" do
            write "file.txt", "a\nbb\n"
          end
          commit "Graph Branch 1 Third Commit" do
            write "file.txt", "a\nbbb\n"
          end
        end

        merge "graph-branch1" do
          write "file.txt", "aaa\nbbb\n"
        end

        commit "Graph Sixth Commit" do
          write "file.txt", "aaaa\nbbb\n"
        end

        branch "graph-branch2" do
          commit "Graph Branch 2 First Commit" do
            write "file.txt", "aaa\nc\n"
          end

          branch "graph-branch3"

          commit "Graph Branch 2 Second Commit" do
            write "file.txt", "aaa\ncc\n"
          end

          branch "graph-branch3" do
            commit "Graph Branch 3 First Commit" do
              write "file.txt", "aaa\nc\nd\n"
            end
            commit "Graph Branch 3 Second Commit" do
              write "file.txt", "aaa\nc\ndd\n"
            end
          end

          merge "graph-branch3" do
            write "file.txt", "aaa\ncc\ndd\n"
          end
        end

        merge "graph-branch2" do
          write "file.txt", "aaaa\nbbb\ncc\ndd\n"
        end

        commit "Graph Eighth Commit" do
          write "file.txt", "aaaaa\nbbb\ncc\ndd\n"
        end

        commit "Graph Nineth Commit" do
          write "file.txt", "aaaaaa\nbbb\ncc\ndd\n"
        end

        branch "graph"
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
        repo.branch('master', &blk)
      end

      finalize_with.each do |method_name|
        repo.send method_name
      end

      repo
    end

    attr_reader :root, :branches, :commits, :shas

    def initialize(root)
      if File.exist?(root) && !File.directory?(root)
        raise "`#{root}` must be a directory"
      end

      @root     = root
      @branches = {}
      @commits  = []
      @shas     = {}

      if File.exist?(root)
        FileUtils.rm_rf(root)
      end
      FileUtils.mkdir_p(root)

      git "init"
    end

    def head
      @shas[branch_sha("master")]
    end

    def branch(name, &blk)
      @branches[name] ||= Branch.new(self, name)
      @branches[name].checkout unless name == "master"
      @branches[name].instance_eval(&blk) if blk
      @branches[name]
    end

    def branch?(name)
      File.exist?("#{@root}/.git/refs/heads/#{name}")
    end

    def branch_sha(name)
      branch?(name) && File.read("#{@root}/.git/refs/heads/#{name}").strip
    end

    def git_repo
      GITRepo.repoWithRoot(@root)
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

    def add_commit(c)
      @commits << c
      @shas[c.sha] = c
    end
  end

  class Branch
    attr_reader :name

    def initialize(repo, name)
      @repo    = repo
      @name    = name

      unless name == "master"
        unless repo.branch?(name)
          git "branch #{name}"
        end
      end
    end

    def checkout
      git "checkout -q #{name}"
    end

    def commit(msg, &blk)
      c = Commit.build(@repo, &blk)
      c.commit!(msg)
      c
    end

    def branch(*args, &blk)
      @repo.branch(*args, &blk)
      git "checkout -q #{name}"
    end

    def merge(name, msg = nil, &blk)
      m = Merge.build(@repo, name, &blk)
      m.commit!(msg)
      m
    end

  private

    def git(*args)
      @repo.git(*args)
    end

  end

  class Commit
    attr_reader :sha, :subject, :author_name, :author_email, :author_date, :committer_name,
                :committer_email, :committer_date, :parents

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
      populate_attributes
    end

  private

    def populate_attributes
      format = %w(%H %s %an %ae %aD %cn %ce %cD %P).join("%n") # %P has to be last
      i = git("log -1 --pretty='format:#{format}'").strip.split("\n")
      @sha             = i[0]
      @subject         = i[1]
      @author_name     = i[2]
      @author_email    = i[3]
      @author_date     = Time.rfc2822(i[4])
      @committer_name  = i[5]
      @committer_email = i[6]
      @committer_date  = Time.rfc2822(i[7])

      @parents = (i[8] || "").strip.split(" ").
        map     { |sha| @repo.shas[sha]   }.
        sort_by { |c|   c.committer_date  }

      @repo.add_commit(self)
    end

    def git(*args)
      @repo.git(*args)
    end

  end

  class Merge < Commit
    def self.build(repo, with, &blk)
      c = new(repo, with)
      c.instance_eval(&blk) if blk
      c
    end

    def initialize(repo, with)
      super(repo)

      git "merge --no-commit #{with}"
    end

    def commit!(msg)
      if msg
        git "commit -qm '#{msg}'"
      else
        git "commit -qF #{@repo.root}/.git/MERGE_MSG"
      end

      raise "Failed the merge" unless $?.to_i == 0

      populate_attributes
    end
  end
end