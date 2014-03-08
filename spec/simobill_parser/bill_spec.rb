require 'spec_helper'
require 'simobill_parser/bill'

module SimobillParser
  describe Bill do
    let(:sample) { File.read('spec/fixtures/sample.xml') }
    let(:bill) { Bill.new(sample) }

    it 'parses records as enumerable of Record' do
      bill.records.must_be_kind_of Enumerable
      bill.records.first.must_be_instance_of Record
      bill.records.count.must_equal 148
    end

    it 'knows all the types' do
      bill.types.sort.must_equal ['Klic v drugo mobilno omr.', 'Klic v omrežje Si.mobil', 'Klic v stacionarno omr.', 'Prenos podatkov', 'SMS sporočilo']
    end

    describe 'by type' do
      it 'filters records by type' do
        bill.filter('Prenos podatkov').must_be_kind_of Enumerable
        bill.filter('SMS sporočilo').first.number.must_equal '041580XXX'
      end

      it 'calculates cost' do
        bill.cost('SMS sporočilo').must_equal 0
        bill.cost('Klic v drugo mobilno omr.').must_equal 0.5013
      end

      it 'calculates exact duration' do
        bill.duration('Klic v drugo mobilno omr.').must_equal '14:19:01'
      end

      it 'calculates billable duration' do
        bill.billable_duration('Klic v drugo mobilno omr.').must_equal '14:37:00'
      end

      it 'calculates exact data transfer' do
        bill.transfers('Prenos podatkov').must_equal '1.81 GB'
      end

      it 'calculates billable data transfer' do
        bill.billable_transfers('Prenos podatkov').must_equal '2.07 GB'
      end
    end
  end
end
