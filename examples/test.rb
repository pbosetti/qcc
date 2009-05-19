#!/usr/bin/env ruby
#
# Created by Paolo Bosetti on 2009-05-18.
# Copyright (c) 2009 University of Trento. All rights 
# reserved.

require "../lib/qcc"
require "rubygems"
require "flotr"

plot = Flotr::Plot.new("EWMA chart")
z = Flotr::Data.new(:label => "z", :color => "black")
xn = Flotr::Data.new(:label => "X", :color => "red")
ucl = Flotr::Data.new(:label => "UCL", :color => "blue")
lcl = Flotr::Data.new(:label => "LCL", :color => "blue")

ewma = QCC::EWMA.new
p ewma
ewma.group_size = 5
i = 0
File.open("diameters.txt") do |f|
  f.each_line do |l|
    groups = l.split.map {|e| e.to_f}
    chart = ewma.update(groups)
    cl = ewma.control_limits
    puts "#{i+=1} #{chart[:xn]}, #{chart[:z]}, #{cl.inspect}"
    z << [i, ewma.last[:z]]
    xn << [i, ewma.last[:xn]]
    lcl << [i, cl[0]]
    ucl << [i, cl[1]]
    ewma.calibrating = (i < 25)
  end
end

plot << z << lcl << ucl << xn
plot.show