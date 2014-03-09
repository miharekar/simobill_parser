require 'bigdecimal'
require 'nokogiri'
require 'simobill_parser/record'
require 'simobill_parser/filtered_records'

module SimobillParser
  class Bill
    def initialize(file)
      @xml = Nokogiri::XML(file)
    end

    def records
      @records ||= parse_records
    end

    def types
      records.map(&:description).uniq
    end

    def filtered(type)
      FilteredRecords.new(records, type)
    end

    private
    def parse_records
      @xml.xpath("//Zapis").map{ |z| Record.new(z) }
    end
  end
end
