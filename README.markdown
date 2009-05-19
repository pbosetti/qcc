EWMA CONTROL CHARTS
===================

Basic usage
-----------
    ewma = QCC::EWMA.new
    ewma.group_size = 5
    i = 0
    File.open("diameters.txt") do |f|
      f.each_line do |l|
        group = l.split.map {|e| e.to_f}
        chart = ewma.update(group)
        cl    = ewma.control_limits
        puts "#{i+=1} #{chart[:xn]}, #{chart[:z]}, #{cl.inspect}"
        ewma.calibrating = (i < 25)
      end
    end

Requirements
------------
No other gems/libraries are required, although you must have the Flotr library installed to have examples work:

    sudo gem install pbosetti-flotr

To Do
-----
At the moment, global mean and standard deviation are routinely updated after adding each group, _including the calibration phase_. This is a different behavior wrt the standard EWMA charts, where the calibrating phase is used to get a value for those indicators.
This is currently due to the recursive formula adopted for mean and standard deviation calculation, and will be corrected in the future revisions.