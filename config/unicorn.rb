APP_ROOT = "/home/ubuntu/anonymouspost"

# Set the working application directory
# working_directory "/path/to/your/app"
working_directory APP_ROOT

# Unicorn PID file location
# pid "/path/to/pids/unicorn.pid"
pid "#{APP_ROOT}/pids/unicorn.pid"

# Path to logs
# stderr_path "/path/to/log/unicorn.log"
# stdout_path "/path/to/log/unicorn.log"
stderr_path "#{APP_ROOT}/log/unicorn.log"
stdout_path "#{APP_ROOT}/log/unicorn.log"

# Unicorn socket
listen "/tmp/unicorn.anonymouspost.sock"

worker_processes 2
timeout 10
preload_app true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end