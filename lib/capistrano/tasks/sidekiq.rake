namespace :sidekiq do
  desc 'Make sidekiq job stop process job'
  task :quiet do
    on roles(:app) do
      # TODO Use sidekiqctl
      puts capture("pgrep -f 'sidekiq' | xargs kill -USR1")
    end
  end

  desc 'Restart sidekiq'
  task :restart do
    on roles(:app) do
      execute :sudo, '/bin/systemctl', :restart, 'sidekiq@1.service'
      execute :sudo, '/bin/systemctl', :restart, 'sidekiq@2.service'
    end
  end
end

after 'deploy:starting', 'sidekiq:quiet'
after 'deploy:reverted', 'sidekiq:restart'
after 'deploy:published', 'sidekiq:restart'
