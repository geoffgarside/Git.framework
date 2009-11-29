task :default => [:test]
task :build => ['build:release']

namespace :build do
  task :debug do
    sh 'xcodebuild -target Git -configuration Debug'
  end
  task :release do
    sh 'xcodebuild -target Git -configuration Release'
  end
end

task :test do
  sh 'xcodebuild -target Tests -configuration Debug'
end

task :documentation => ['documentation:release']
namespace :documentation do
  task :debug do
    sh 'xcodebuild -target Documentation -configuration Debug'
  end
  task :release do
    sh 'xcodebuild -target Documentation -configuration Release'
  end
end

namespace :website do
  task :update => [:documentation] do
    sh 'rsync -tav --delete --exclude .git Documentation/cxhtml/ Website/'
  end
  task :commit => :update do
    Dir.chdir('Website') do
      sh 'git commit -a -m "Update Website"'
    end
    sh 'git commit Website -m "Update Website"'
  end
  task :push do
    Dir.chdir('Website') do
      sh 'git push origin gh-pages'
    end
  end
end
