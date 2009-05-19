#!/usr/bin/env ruby
#
# Created by Paolo Bosetti on 2009-05-18.
# Copyright (c) 2009 University of Trento. All rights 
# reserved.

require "../lib/qcc"

ewma = QCC::EWMA.new :L => 2, :lambda => 0.14
ewma.lambda = 2
p ewma
