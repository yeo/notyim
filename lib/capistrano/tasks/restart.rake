namespace :puma do
  desc 'Restar puma'
  task :restart do
    on roles (fetch(:app)) do |role|
      within current_path do
        with rack_env: fetch(:stage) do
          execute :rails, :restart
        end
      end
    end
  end
end
after 'deploy:finished', 'puma:restart'
