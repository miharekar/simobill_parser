require 'spec_helper'
require 'simobill_parser/record'
require 'nokogiri'

module SimobillParser
  describe Record do
    let(:sample) { File.read('spec/fixtures/sample.xml') }
    let(:records) { Nokogiri::XML(sample).xpath("//Zapis") }
    let(:record) { Record.new(records.first) }

    it 'parses date' do
      record.date.must_equal DateTime.new(0, 11, 12, 13, 14)
    end

    it 'parses description' do
      record.description.must_equal 'Klic v drugo mobilno omr.'
    end

    it 'parses number' do
      record.number.must_equal '041946XXX'
    end

    it 'parses provider' do
      record.provider.must_equal 'SVNSM'
    end

    it 'parses duration' do
      record.duration.must_equal '00:00:24'
    end

    it 'parses cost' do
      record.cost.must_equal '0.0000'
    end

    it 'parses type' do    
      record.type.must_equal :phone
      Record.new(records[1]).type.must_equal :data
      Record.new(records[23]).type.must_equal :sms
    end
  end
end
