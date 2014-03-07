require 'spec_helper'

module SimobillParser
  describe Record do
    let(:sample) { File.read('spec/fixtures/sample.xml') }
    let(:record) { Record.new(Nokogiri::XML(sample).xpath("//Zapis").first) }

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
  end
end
