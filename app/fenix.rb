class Fenix
  include Concord.new(:filename)

  def data
    @data ||= JSON.parse(File.read(filename))
  end

  def prefix
    data.fetch('prefix')
  end

  def each
    data.fetch('groups', []).each do |group|
      yield(group)
    end
  end
end
