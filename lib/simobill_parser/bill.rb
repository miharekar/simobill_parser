require 'bigdecimal'
require 'nokogiri'
require 'filesize'
require_relative 'record'

module SimobillParser
  class Bill
    def initialize(file)
      @xml = Nokogiri::XML(file)
    end

    def records
      @records ||= parse_records
    end

    def types
      @types ||= records.map(&:description).uniq
    end

    def filter(type)
      records.select{ |r| r.description == type }
    end

    def cost(type)
      filter(type).inject(0){ |sum, r| sum + BigDecimal.new(r.cost) }.to_f
    end

    def exact(type)
      if filter(type).first.duration =~ /:/
        duration(type)
      else
        transfers_size(type)
      end
    end

    def billable(type)
      if filter(type).first.duration =~ /:/
        billable_duration(type)
      else
        billable_transfers_size(type)
      end
    end

    def duration(type)
      s = filter(type).inject(0) { |sum, r| sum + seconds_from_duration(r.duration) }
      Time.at(s).utc.strftime('%H:%M:%S')
    end

    def billable_duration(type)
      s = filter(type).inject(0) do |sum, r|
        sum + seconds_from_duration(get_billable_duration(r.duration))
      end
      Time.at(s).utc.strftime('%H:%M:%S')
    end

    def transfers_size(type)
      filter(type).inject(0) do |sum, r|
        sum + Filesize.from(r.duration.gsub(',', '.'))
      end
    end

    def billable_transfers_size(type)
      filter(type).inject(0) do |sum, r|
        sum + Filesize.from(get_billable_transfer_size(r.duration))
      end
    end

    private
    def parse_records
      @xml.xpath("//Zapis").map{ |z| Record.new(z) }
    end

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
end
