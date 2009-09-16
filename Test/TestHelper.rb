def append_framework_path(*paths)
  ENV['DYLD_FRAMEWORK_PATH'] ||= ""
  ENV['DYLD_FRAMEWORK_PATH'] = ENV['DYLD_FRAMEWORK_PATH'].split(":").unshift(*paths).join(":")
end

append_framework_path File.join(File.dirname(__FILE__) +'/../build/Debug')

framework 'Git'
require 'test/unit'
require 'rubygems'
require 'shoulda'
require 'shoulda/test_unit'

# hdiutil create -volname "Git Test Repos" -fs HFS+J -layout GPTSPUD -size 2m Test/Resources/repos.dmg

TEST_REPO = "/Volumes/Git Test Repos"

unless File.exist? TEST_REPO
  puts 'Mounting git repository disk image'
  `hdiutil attach #{File.join(File.dirname(__FILE__), 'Resource/repos.dmg')}`
end
