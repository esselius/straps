class Fenix
  include Concord.new(:data)

  def region
    data.fetch('region')
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
