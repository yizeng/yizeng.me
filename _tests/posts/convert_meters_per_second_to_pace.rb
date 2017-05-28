require 'test/unit'

module ConvertMetersPerSecondToPace
  class ConvertMetersPerSecondToPaceTests < Test::Unit::TestCase
    def test_convert_nil
      assert_equal('', convert_meters_per_second_to_pace(nil))
    end

    def test_convert_zero_speed
      assert_equal('', convert_meters_per_second_to_pace(0))
    end

    def test_convert_to_min_km
      assert_equal('4:40', convert_meters_per_second_to_pace(3.566))
      assert_equal('5:05', convert_meters_per_second_to_pace(3.274))
    end

    def test_convert_to_min_mile
      assert_equal('6:37', convert_meters_per_second_to_pace(4.05, 'mile'))
      assert_equal('7:13', convert_meters_per_second_to_pace(3.716, 'mile'))
    end

    private
    # Convert speed (m/s) to pace (min/mile or min/km) in the format of 'x:xx'
    def convert_meters_per_second_to_pace(speed, unit = nil)
      if speed.nil? || speed == 0
        return ''
      end

      total_seconds = unit == 'mile' ? (1609.344 / speed) : (1000 / speed)
      minutes, seconds = total_seconds.divmod(60)
      seconds = seconds.round < 10 ? "0#{seconds.round}" : "#{seconds.round}"
      "#{minutes}:#{seconds}"
    end
  end
end
