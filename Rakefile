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

desc "Runs the test suite for the framework (Requires MacRuby)"
task :test do
  sh 'xcodebuild -target Tests -configuration Debug'
end

desc "Generates the documentation for the framework (Requires Doxygen and appledoc)"
task :documentation => ['documentation:release']
namespace :documentation do
  desc "Generates the debug version of the documentation for the framework (Requires Doxygen and appledoc)"
  task :debug do
    sh 'xcodebuild -target Documentation -configuration Debug'
  end
  desc "Generates the release version of the documentation for the framework (Requires Doxygen and appledoc)"
  task :release do
    sh 'xcodebuild -target Documentation -configuration Release'
  end
end

namespace :website do
  desc "Update the website data from the generated documentation"
  task :update => [:documentation] do
    sh 'rsync -tav --delete --exclude .git Documentation/cxhtml/ Website/'
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

namespace :check_tabs do
  desc "Checks staged files for tab characters"
  task :staged do
    puts "Checking for tab characters in staged files..."
    `git diff --cached --name-only`.split("\n").each do |srcfile|
      check_for_tabs_in srcfile
    end
  end
  desc "Checks source files for tab charactesr"
  task :source do
    puts "Checking for tab characters in Source/ files..."
    Dir.glob("Source/**/*.[hm]").each do |srcfile|
      check_for_tabs_in srcfile
    end
  end
  desc "Installs the git hook to check staged files for tabs before commit"
  task :install_hook do
    hook_file = ".git/hooks/pre-commit"
pre_commit = <<EOF
#!/usr/bin/env ruby

found = []
`git diff --staged --name-only`.split("\\n").each do |srcfile|
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
  end
end
