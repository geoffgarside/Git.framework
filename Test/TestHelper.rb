def append_framework_path(*paths)
  ENV['DYLD_FRAMEWORK_PATH'] ||= ""
  ENV['DYLD_FRAMEWORK_PATH'] = ENV['DYLD_FRAMEWORK_PATH'].split(":").unshift(*paths).join(":")
end

append_framework_path File.join(File.dirname(__FILE__) +'/../build/Debug')

require 'bacon'
framework 'Git'

Bacon.extend Bacon::TestUnitOutput  # This doesn't seem to work at the moment, but its how we'd prefer it
Bacon.summary_on_exit

# hdiutil create -volname "Git Test Repos" -fs HFS+J -layout GPTSPUD -size 2m Test/Resources/repos.dmg

TEST_VOLUME = "/Volumes/Git Test Repos"
TEST_REPO = File.join(TEST_VOLUME, 'Test')
TEST_REPO_ROOT = "#{TEST_REPO}/.git"

unless File.exist? TEST_VOLUME
  puts 'Mounting git repository disk image'
  `hdiutil attach #{File.join(File.dirname(__FILE__), 'Resource/repos.dmg')}`
end

require File.expand_path(File.dirname(__FILE__) +'/Helpers/GITError.rb')

def default_repository
  GITRepo.repoWithRoot(TEST_REPO)
end
