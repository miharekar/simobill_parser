require 'filesize'

class FilteredRecords
  include Enumerable
  extend Forwardable
  def_delegators :@records, :each
  attr_reader :name

  def initialize(records, name)
    @records = records.select{ |r| r.description == name }
    @name = name
  end

  def cost
    inject(0){ |sum, r| sum + BigDecimal.new(r.cost) }.to_f
  end

  def duration
    s = inject(0) { |sum, r| sum + seconds_from_duration(r.duration) }
    Time.at(s).utc.strftime('%H:%M:%S')
  end

  def billable_duration
    s = inject(0) do |sum, r|
      sum + seconds_from_duration(get_billable_duration(r.duration))
    end
    Time.at(s).utc.strftime('%H:%M:%S')
  end

  def transfers_size
    inject(0) do |sum, r|
      sum + Filesize.from(r.duration.gsub(',', '.'))
    end
  end

  def billable_transfers_size
    inject(0) do |sum, r|
      sum + Filesize.from(get_billable_transfer_size(r.duration))
    end
  end

  def type
    first.type
  end

  private
  def seconds_from_duration(duration)
    Time.parse(duration).to_i - Time.parse('00:00:00').to_i
  end

  # billable interval is 60/60
  def get_billable_duration(duration)
    d = duration.split(':').map(&:to_i)
    if d[2] > 0
      d[1] += 1
      d[2] = 0
    end
    d.join(':')
  end

  # billable interval is 10kB
  def get_billable_transfer_size(transfer)
    kb = Filesize.from(transfer.gsub(',', '.')).to_f('KB')
    kb = (kb / 10).ceil * 10
    "#{kb}KB"
  end
end
