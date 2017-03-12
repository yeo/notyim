namespace :puma do
  desc 'Restart puma'
  task :restart do
    on roles(:app) do |role|
      within current_path do
        with rack_env: fetch(:stage) do
          execute :chmod, '-R o+r', "#{shared_path}/public"
          execute :sudo, '/bin/systemctl', :restart, 'trinity.service'
          #puts capture("ps aux | grep [p]uma |awk '{print $2}' | xargs kill -s SIGUSR2")
        end
      end
    end
  end
end

namespace :pumactl do
  task :restart do
    on roles fetch(:app) do |role|
      #execute :pumactl, '-C', 'tcp://127.0.0.1:9293', '-T', fetch(:PUMACTL_TOKEN), :restart
    end
  end
end

after 'deploy:published', 'puma:restart'
