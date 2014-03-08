require 'bigdecimal'
require 'nokogiri'
require_relative 'record'

module SimobillParser
  class Bill
    def initialize(file)
      @xml = Nokogiri::XML(file)
    end

    def records
      @records ||= parse_records
    end

    def filter(type)
      records.select{ |r| r.description == type }
    end

    def cost(type)
      filter(type).inject(0){ |sum, r| sum + BigDecimal.new(r.cost) }.to_f
    end

    def duration(type)
      s = filter(type).inject(0) { |sum, r| sum + seconds_from_duration(r.duration)}
      Time.at(s).utc.strftime('%H:%M:%S')
    end

    private
    def parse_records
      @xml.xpath("//Zapis").map{ |z| Record.new(z) }
    end

    def seconds_from_duration(duration)
      Time.parse(duration).to_i - Time.parse('00:00:00').to_i 
    end
  end
end
