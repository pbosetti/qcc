#!/usr/bin/env ruby
#
# Created by Paolo Bosetti on 2009-05-18.
# Copyright (c) 2009 University of Trento. All rights 
# reserved.

class Array
  def extr
    [self.min, self.max]
  end
  
  def mean
  	self.inject(0) {|sum, i| sum + i}/self.length.to_f
  end

  def sd
  	m=self.mean
  	begin
      Math::sqrt(self.inject(0) {|sum, i| sum + (i-m)**2}/(self.length.to_f-1))
    rescue
      0.0
    end
  end
end

module QCC
  class EWMA
    attr_accessor :r, :k, :i, :g, :last, :n
    attr_accessor :calibrating, :ref
    
    def initialize(r = 0.2, k = 3.0, g = 3)
      @r = r
      @k = k
      @g = g
      @i = 0
      @last = {}
      @calibrating = true
    end
    
    def update(group)
      raise "Groups must be of size #{@g}" unless group.size == @g
      if @last[:xn] and @last[:sn]
        xn, sn = @last[:xn], @last[:sn]
      else
        xn, sn = group[0], 0.0
      end
      group.each_with_index do |x,i|
        n = @i * @g + i + 1
        xn = 1.0/n * ((n-1)*xn + x) if n > 1
        sn = n > 1 ? n/(n-1.0)*(xn - x)**2 + sn : 0.0
        sd = n > 1 ? Math::sqrt(1.0/(n-1.0)*sn) : nil
      end
      @i += 1
      @n = @i * @g
      if @last[:z]
        @last[:z] = @last[:z] + @r*(group.mean - @last[:z])
      else
        @last[:z] = xn
      end
      if @calibrating
        @last[:xn], @last[:sn] = xn, sn
        @last[:sd] = Math::sqrt(1.0/(@n-1)*sn)
      end
      @last
    end
    
    def control_limits
      range = @k * @last[:sd] * Math.sqrt(@r * (1-(1-@r)**(2*@i))/(@g*(2-@r)))
      [@last[:xn] - range, @last[:xn] + range]
    end
    
  end
end