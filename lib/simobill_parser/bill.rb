require 'nokogiri'

module SimobillParser
  class Bill
    def initialize(file)
      @xml = Nokogiri::XML(file)
    end

    def records
      @records ||= parse_records
    end

    private
    def parse_records
      @xml.xpath("//Zapis").map{ |z| Record.new(z) }
    end
  end
end
