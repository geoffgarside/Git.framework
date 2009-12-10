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
