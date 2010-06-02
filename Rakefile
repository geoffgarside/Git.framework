desc "Default task (test)"
task :default => [:test]

desc "Builds the release version of the framework"
task :build => ['build:release']

namespace :build do
  desc "Builds the debug version of the framework"
  task :debug do
    sh 'xcodebuild -target Git -configuration Debug'
  end
  desc "Builds the release version of the framework"
  task :release do
    sh 'xcodebuild -target Git -configuration Release'
  end
end

namespace :bridgesupport do
  desc 'Generate the BridgeSupport MetaData'
  task :generate => ['build:release'] do
    sh 'gen_bridge_metadata -f ./build/Release/Git.framework -o ./Resource/BridgeSupport/Git.bridgesupport --64-bit'
  end
end

namespace :check do
  task :framework_header => ['build:release'] do
    imports = Dir['build/Release/Git.framework/Headers/*.h'].map do |f|
      '#import "%s"' % File.basename(f)
    end

    imports.delete('#import "Git.h"')
    File.open('Source/Git.h', 'r') do |f|
      f.each_line do |l|
        imports.delete(l.chomp)
      end
    end

    unless imports.empty?
      puts "Missing Git.h imports:"
      puts imports.map { |l| "    #{l}" }.join("\n")
    else
      puts "Git.h is complete"
    end
  end
end

desc "Runs the test suite for the framework (Requires MacRuby)"
task :test do
  # Need to use system instead of sh to avoid a segv on macruby 0.6
  system 'xcodebuild -target Tests -configuration Debug'
end

test_pattern = /^test\:(.*)$/
rule test_pattern do |t|
  ENV['TEST_PAT'] = t.name[test_pattern, 1]
  Rake::Task['test'].invoke
end

desc "Generates the documentation for the framework (Requires Doxygen)"
task :documentation => ['documentation:release']
namespace :documentation do
  desc "Generates the debug version of the documentation for the framework (Requires Doxygen)"
  task :debug do
    sh 'xcodebuild -target Documentation -configuration Debug'
  end
  desc "Generates the release version of the documentation for the framework (Requires Doxygen)"
  task :release do
    sh 'xcodebuild -target Documentation -configuration Release'
  end
  task :clean do
    sh 'rm -r Documentation/{html,tmp,xml}'
  end
  file 'Documentation/html/index.html' => 'documentation:release'
  task :open => 'Documentation/html/index.html' do
    sh 'open Documentation/html/index.html'
  end
end

namespace :website do
  desc "Update the website data from the generated documentation"
  task :update => [:documentation] do
    sh 'rsync -tav --delete --exclude .git Documentation/html/ Website/'
  end
  desc "Commit the updated website data"
  task :commit => :update do
    Dir.chdir('Website') do
      sh 'git commit -a -m "Update Website"'
    end
    sh 'git commit Website -m "Update Website"'
  end
  desc "Push the updated website to the gh-pages branch"
  task :push do
    Dir.chdir('Website') do
      sh 'git push origin gh-pages'
    end
  end
end

def check_for_tabs_in(srcfile)
  line_number = 0
  File.readlines(srcfile).each do |line|
    line_number += 1
    if line.index("\t")
      puts "#{srcfile}:#{line_number}\t#{line}"
    end
  end
end

def matches_mime?(file)
  @ignored_mime_types ||= `git config pre-commit.ignored.mime`.chomp.split(" ")

  mime_type = `file --mime-type -b "\#{file}"`.chomp
  @ignored_mime_types.any? {|t| mime_type =~ /^#{t}/ }
end
def matches_ext?(file)
  @ignored_extensions ||= `git config pre-commit.ignored.extensions`.chomp.split(" ")
  @ignored_extensions.any? {|e| file =~ /\.#{e}$/ }
end

namespace :check_tabs do
  desc "Checks staged files for tab characters"
  task :staged do
    puts "Checking for tab characters in staged files..."
    `git diff --cached --name-only`.split("\n").each do |srcfile|
      next unless File.file?(srcfile)
      next if srcfile =~ /^\.git/
      next if matches_ext?(srcfile)
      next if matches_mime?(srcfile)

      check_for_tabs_in srcfile
    end
  end
  desc "Checks source files for tab charactesr"
  task :source do
    puts "Checking for tab characters in Source/ files..."
    Dir.glob("Source/**/*.[hm]").each do |srcfile|
      next unless File.file?(srcfile)
      next if srcfile =~ /^\.git/
      next if matches_ext?(srcfile)
      next if matches_mime?(srcfile)

      check_for_tabs_in srcfile
    end
  end
  desc "Installs the git hook to check staged files for tabs before commit"
  task :install_hook do
    hook_file = ".git/hooks/pre-commit"
pre_commit = <<EOF
#!/usr/bin/env ruby

def matches_mime?(file)
  @ignored_mime_types ||= `git config pre-commit.ignored.mime`.chomp.split(" ")

  mime_type = `file --mime-type -b "\#{file}"`.chomp
  @ignored_mime_types.any? {|t| mime_type =~ /^\#{t}/ }
end
def matches_ext?(file)
  @ignored_extensions ||= `git config pre-commit.ignored.extensions`.chomp.split(" ")
  @ignored_extensions.any? {|e| file =~ /\\.\#{e}$/ }
end

found = []
`git diff --staged --name-only`.split("\\n").each do |srcfile|
  next unless File.file?(srcfile)
  next if srcfile =~ /^\.git/
  next if matches_ext?(srcfile)
  next if matches_mime?(srcfile)

  line_number = 0
  File.readlines(srcfile).each do |line|
    line_number += 1
    if line.index("\\t")
      found << "\#{srcfile}:\#{line_number}\\t\#{line}"
    end
  end
end

unless found.empty?
  puts "Error: Attempt to add file with tab indentation"
  puts ""
  puts "This project uses spaces rather than tabs for indendation,"
  puts "please fix the lines of the following files and then re-add"
  puts "the files to the index and re-commit.\\n\\n"
  puts found.join("\\n")
  exit 1
end

exit 0
EOF
    if File.exists?(hook_file)
      puts "You already have a pre-commit hook, either remove it or add the following"
      puts "----- Add to #{hook_file} -----"
      puts pre_commit
      puts "-------------------------------"
    else
      File.open(hook_file, "w") do |f|
        f.write(pre_commit)
      end
      FileUtils.chmod(0755, hook_file)
    end

    puts "Pre Commit hook successfully installed, please note configuration is via `git config`"
    puts "the following commands are recommended to ignore files for Tab checking"
    puts "  $ git config pre-commit.ignored.mime 'image/ application/xml application/octet-stream'"
    puts "  $ git config pre-commit.ignored.extensions 'graffle pbxproj'"
  end
end
