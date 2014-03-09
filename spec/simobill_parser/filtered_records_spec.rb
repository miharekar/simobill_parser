require 'spec_helper'
require 'simobill_parser/bill'
require 'simobill_parser/filtered_records'

module SimobillParser
  describe FilteredRecords do
    let(:bill) { Bill.new(File.read('spec/fixtures/sample.xml')) }

    it 'filters record on initialization' do
      filtered = FilteredRecords.new(bill.records, 'SMS sporočilo')
      filtered.count.must_equal 24
      filtered.must_be_kind_of Enumerable
      filtered.first.must_be_kind_of Record
      filtered.first.number.must_equal '041580XXX'
    end

    it 'calculates cost' do
      filtered = FilteredRecords.new(bill.records, 'SMS sporočilo')
      filtered.cost.must_equal 0

      filtered = FilteredRecords.new(bill.records, 'Klic v drugo mobilno omr.')
      filtered.cost.must_equal 0.5013
    end

    it 'calculates exact duration' do
      filtered = FilteredRecords.new(bill.records, 'Klic v drugo mobilno omr.')
      filtered.duration.must_equal '14:19:01'
    end

    it 'calculates billable duration' do
      filtered = FilteredRecords.new(bill.records, 'Klic v drugo mobilno omr.')
      filtered.billable_duration.must_equal '14:37:00'
    end

    it 'calculates exact data transfer size' do
      filtered = FilteredRecords.new(bill.records, 'Prenos podatkov')
      filtered.transfers_size.to_f('KB').must_equal 1813751.87
    end

    it 'calculates billable data transfer size' do
      filtered = FilteredRecords.new(bill.records, 'Prenos podatkov')
      filtered.billable_transfers_size.to_f('KB').must_equal 1813880.0
    end
  end
end
