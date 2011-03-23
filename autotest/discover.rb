# autotest/discover.rb
require File.dirname(__FILE__) + '/testunit'

Autotest.add_discovery { "testunit" }
