#!/usr/bin/env ruby
#
# Created by Paolo Bosetti on 2009-05-18.
# Copyright (c) 2009 University of Trento. All rights 
# reserved.

module QCC
  class EWMA
    PARS = {:lambda => 0.1, :L => 3, :n => 5}
    attr_accessor :parameters, :xav, :n
    
    def initialize(pars={})
      @parameters = PARS.merge pars
      
    end
    
    def lcl; @xav - self.control_range; end
    def ucl; @xav + self.control_range; end
    def control_range
      l, lambda = @parameters[:lambda], @parameters[:L]
      l * self.sigma * Math.sqrt(lambda * (1-(1-r)**(2*i))/(n*(2-lambda)))
    end
    
    def method_missing(method, *args)
      if method.to_s =~ /^(.*)=$/
        raise NoMethodError, "No attribute #{method}" unless PARS[$1.to_sym]
        @parameters[$1] = args[0]
      else
        raise NoMethodError, "No attribute #{method}" unless PARS[method.to_sym]
        @parameters[method]
      end
    end
    
  end
end