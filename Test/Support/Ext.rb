class File
  def self.write(file, content)
    File.open(file, 'w') { |f| f.write content }
  end
end