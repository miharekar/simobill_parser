class Record
  def initialize(data)
    @data = data
  end

  def date
    @date ||= parse_date
  end

  def description
    @description ||= value_for('Opis')
  end

  def number
    @number ||= value_for('Stevilka')
  end

  def provider
    @provider ||= value_for('Operater')
  end

  def duration
    @duration ||= value_for('Trajanje')
  end

  def cost
    @cost ||= value_for('EUR')
  end

  private
  def value_for(property)
    @data.at_xpath(property).content
  end

  def parse_date
    date = value_for('Datum').split('.').map(&:to_i)
    time = value_for('Ura').split(':').map(&:to_i)
    DateTime.new(0, date[1], date[0], time[0], time[1])
  end
end
