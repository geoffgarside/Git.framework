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
