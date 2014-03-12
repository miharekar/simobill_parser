module SimobillHelper
  def get_duration_value(duration)
    if duration =~ /:/
      Time.parse(duration).to_i
    else
      Filesize.from(duration.gsub(',', '.')).to_f('MB')
    end
  end
end
