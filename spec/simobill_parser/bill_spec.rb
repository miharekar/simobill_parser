require 'spec_helper'

module SimobillParser
  describe Bill do
    let(:sample) { File.read('spec/fixtures/sample.xml') }
    let(:bill) { Bill.new(sample) }

    it 'parses records as enumerable of Record' do
      bill.records.must_be_kind_of Enumerable
      bill.records.first.must_be_instance_of Record
    end
  end
end
