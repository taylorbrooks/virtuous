class FixturesHelper
  def self.read(path)
    File.binread(File.join(FIXTURES_DIR, path))
  end
end
