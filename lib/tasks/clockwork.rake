namespace :clockwork do
  desc 'Start the clockwork daemon'
  task :start => :environment do
    pid = fork do
      $stdout.reopen("/dev/null")
      $stdout.sync = true
      $stderr.reopen($stdout)

      require "clockwork"
      include Clockwork
      prout

      run

    end
    Process.detach(pid)
    File.open("./tmp/pids/clockwork_#{Rails.env}.pid", "w") do |file|
      file << pid
    end
  end

  desc "Stop the clockwork daemon"
  task :stop => :environment do
    pid = File.read("./tmp/pids/clockwork_#{Rails.env}.pid").to_i
    Process.kill(1, pid)
  end

  desc 'restart the clockwork daemon'
  task :restart => [:stop, :start]
end
