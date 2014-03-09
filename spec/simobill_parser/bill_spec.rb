require 'spec_helper'
require 'simobill_parser/bill'

module SimobillParser
  describe Bill do
    let(:bill) { Bill.new(File.read('spec/fixtures/sample.xml')) }

    it 'parses records as enumerable of Record' do
      bill.records.must_be_kind_of Enumerable
      bill.records.first.must_be_instance_of Record
      bill.records.count.must_equal 148
    end

    it 'knows all the types' do
      bill.types.sort.must_equal ['Klic v drugo mobilno omr.', 'Klic v omrežje Si.mobil', 'Klic v stacionarno omr.', 'Prenos podatkov', 'SMS sporočilo']
    end

    it 'returns FilteredRecords by type' do
      bill.filtered('Prenos podatkov').must_be_kind_of FilteredRecords
      bill.filtered('SMS sporočilo').count.must_equal 24
    end
  end
end
