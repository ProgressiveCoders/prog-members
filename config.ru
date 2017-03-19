# This file is used by Rack-based servers to start the application.

run lambda { |_| [200, {'Content-Type'=>'text/plain'}, StringIO.new("Up.\n")] }
