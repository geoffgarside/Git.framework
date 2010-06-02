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
        branch "another"
        tag "v0.0.0", :msg => "v0.0.0"
        commit "Update testfile.txt" do
          write "testfile.txt", "Git Rocks, and rolls!!!\n"
        end
      end
    end

    def graph_repository
      @graph_repository ||= repository "Graph" do
        time = Time.now - 86400
        commit "Graph First Commit", time do
          write "file.txt", ""
        end
        commit "Graph Second Commit", time += 60 do
          write "file.txt", "a\n"
        end

        branch "graph-branch1"

        commit "Graph Third Commit", time += 60 do
          write "file.txt", "aa\n"
        end
        commit "Graph Fourth Commit", time += 60 do
          write "file.txt", "aaa\n"
        end

        branch "graph-branch2"

        branch "graph-branch1" do
          commit "Graph Branch 1 First Commit", time += 60 do
            write "file.txt", "a\nb1\n"
          end
          commit "Graph Branch 1 Second Commit", time += 60 do
            write "file.txt", "a\nbb\n"
          end
          commit "Graph Branch 1 Third Commit", time += 60 do
            write "file.txt", "a\nbbb\n"
          end
        end

        merge "graph-branch1", time += 60 do
          write "file.txt", "aaa\nbbb\n"
        end

        commit "Graph Sixth Commit", time += 60 do
          write "file.txt", "aaaa\nbbb\n"
        end

        branch "graph-branch2" do
          commit "Graph Branch 2 First Commit", time += 60 do
            write "file.txt", "aaa\nc\n"
          end

          branch "graph-branch3"

          commit "Graph Branch 2 Second Commit", time += 60 do
            write "file.txt", "aaa\ncc\n"
          end

          branch "graph-branch3" do
            commit "Graph Branch 3 First Commit", time += 60 do
              write "file.txt", "aaa\nc\nd\n"
            end
            commit "Graph Branch 3 Second Commit", time += 60 do
              write "file.txt", "aaa\nc\ndd\n"
            end
          end

          merge "graph-branch3", time += 60 do
            write "file.txt", "aaa\ncc\ndd\n"
          end
        end

        merge "graph-branch2", time += 60 do
          write "file.txt", "aaaa\nbbb\ncc\ndd\n"
        end

        commit "Graph Eighth Commit", time += 60 do
          write "file.txt", "aaaaa\nbbb\ncc\ndd\n"
        end

        commit "Graph Nineth Commit", time += 60 do
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
      File.exist?("#{heads_path}/#{name}")
    end

    def branch_sha(name)
      branch?(name) && File.read("#{heads_path}/#{name}").strip
    end

    def git_repo
      GITRepo.repoWithRoot(@root)
    end

    def commit(subject)
      commits.find { |c| c.subject == subject }
    end

    def tags
      @tags ||= begin
        tags = {}
        git("tag").strip.split("\n").each do |name|
          tags[name] = Tag.new(self, name)
        end
        tags
      end
    end

    def repack
      git "repack -q"
      pack_files.each do |file|
        out = file.sub(/\.pack$/, '-v1.idx')
        git "index-pack --index-version=1 -o #{out} #{file}"
      end
    end

    def pack_refs
      git "pack-refs --all"
    end

    def git(cmd)
      Dir.chdir(@root) { %x'git #{cmd}' }
    end

    def pack_files_with_indexes
      Dir["#{@root}/.git/objects/pack/pack-*.pack"].map do |pack|
        [ pack, pack.sub(/\.pack$/, '-v1.idx'), pack.sub(/pack$/, 'idx') ]
      end
    end

    def v1_indexes
      v1_index_files.map { |f| Index.new(f, git("show-index < #{f}")) }
    end

    def indexes
      index_files.map { |f| Index.new(f, git("show-index < #{f}")) }
    end

    def v1_index_files
      pack_files_with_indexes.map { |pack, indexv1, indexv2| indexv1 }
    end

    def index_files
      pack_files_with_indexes.map { |pack, indexv1, indexv2| indexv2 }
    end

    def pack_files
      pack_files_with_indexes.map { |pack, indexv1, indexv2| pack }
    end

    def delete_pack_index_files!
      pack_files_with_indexes.each do |pack, idxv1, idxv2|
        FileUtils.rm_rf(idxv1)
        FileUtils.rm_rf(idxv2)
      end
    end

    def add_commit(c)
      @commits << c
      @shas[c.sha] = c
    end

    def heads_path
      "#{@root}/.git/refs/heads"
    end

    def pack_path
      "#{objects_path}/pack"
    end

    def objects_path
      "#{@root}/.git/objects"
    end

    def tags_path
      "#{@root}/.git/refs/tags"
    end
  end

  class Index
    attr_reader :file

    def initialize(file, output)
      @file = file
      @shas = {}
      @indexes = []
      output.strip.split("\n").each do |line|
        offset, sha = line.split(" ")
        @shas[sha] = offset.to_i
        @indexes << sha
      end
    end

    def [](sha)
      @shas[sha]
    end

    # Only needed for ReverseIndex which probably
    # won't stay around too much longer.
    def index(sha)
      @indexes.index(sha)
    end

    def to_a
      @indexes.map { |sha| { :sha => sha, :offset => @shas[sha] } }.sort_by { |i| i[:offset] }
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

    def commit(msg, date = nil, &blk)
      c = Commit.build(@repo, &blk)
      c.commit!(msg, date)
      c
    end

    def tag(name, options = {})
      if msg = options[:msg]
        git "tag -a #{name} -m #{msg}"
      else
        git "tag #{name}"
      end
    end

    def branch(*args, &blk)
      @repo.branch(*args, &blk)
      git "checkout -q #{name}"
    end

    def merge(name, date = nil, msg = nil, &blk)
      m = Merge.build(@repo, name, &blk)
      m.commit!(msg, date)
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

    def commit!(msg, date = nil)
      unless date.nil?                  # Set the author and committer date
        ENV['GIT_AUTHOR_DATE'] = ENV['GIT_COMMITTER_DATE'] = date.strftime("%s %z")
      end

      git "commit -qm '#{msg}'"

      ENV.delete('GIT_AUTHOR_DATE')     # Cleanup the date env variables
      ENV.delete('GIT_COMMITTER_DATE')

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

    def commit!(msg, date = nil)
      unless date.nil?                  # Set the author and committer date
        ENV['GIT_AUTHOR_DATE'] = ENV['GIT_COMMITTER_DATE'] = date.strftime("%s %z")
      end

      if msg
        git "commit -qm '#{msg}'"
      else
        git "commit -qF #{@repo.root}/.git/MERGE_MSG"
      end

      raise "Failed the merge" unless $?.to_i == 0

      ENV.delete('GIT_AUTHOR_DATE')     # Cleanup the date env variables
      ENV.delete('GIT_COMMITTER_DATE')

      populate_attributes
    end
  end

  class Tag
    attr_reader :name, :sha, :ref, :tagger_name, :tagger_email, :date

    def initialize(repo, name)
      @repo, @name = repo, name

      data = git "show #{name}"
      @sha = git("rev-parse #{name}").strip

      if data =~ /\Acommit/
        @ref = @sha
      else
        name_email = /Tagger:\s*(.*)\s+<(.*?)>$/
        @tagger_name  = data[name_email, 1]
        @tagger_email = data[name_email, 2]
        @date = Time.parse(data[/Date:\s*(.*)$/, 1])
        @ref = data[/commit ([0-9a-f]{40})$/, 1]
      end
    end

  private

    def git(*args)
      @repo.git(*args)
    end

  end
end