namespace :puma do
  desc 'Restart puma'
  task :restart do
    on roles (fetch(:app)) do |role|
      within current_path do
        with rack_env: fetch(:stage) do
          #execute :sudo, '/bin/systemctl', :restart, 'trinity.service'
          puts capture("pgrep -f 'puma' | xargs kill -s SIGUSR2")
        end
      end
    end
  end
end

after 'deploy:finished', 'puma:restart'
