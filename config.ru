run lambda { |env| sleep 300; [200, {'Content-Type'=>'text/plain'}, StringIO.new("Hello World!\n")] }
