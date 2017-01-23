namespace :deploy do
  desc 'Install npm package using yarn'
  task :yarn do
    on release_roles(fetch(:assets_roles)) do
      within release_path do
        execute :yarn, :install
      end
    end
  end
end

before 'deploy:updated', 'deploy:yarn'
