# config valid for current version and patch releases of Capistrano
lock "3.12.1"
# デプロイするアプリケーション名
set :application, "sns_app"
# cloneするgitのレポジトリ
set :repo_url, "git@github.com:sori14/sns_app.git"
# デプロイに使うユーザ
set :user, "sori14"
# deployするブランチ
set :branch, 'master'
# deploy先のディレクトリ
set :deploy_to, '/var/www/rails/sns_app'
# シンボリックリンクをはるファイル
# set :linked_files, fetch(:linked_files, []).push('config/settings.yml')
# シンボリックリンクをはるフォルダ
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
# 保持するバージョンの個数
set :keep_releases, 5
# rubyのバージョン
set :rbenv_ruby, '2.5.1'
# 出力するログのレベル
set :log_level, :debug
# コネクション継続
set :ssh_options, {
    keepalive: true,
    user: fetch(:user),
    keys: %w(~/.ssh/github_id_rsa.pub)
}

namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end

  desc 'Create database'
  task :db_create do
    on roles(:db) do |host|
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :rails, 'db:create'
        end
      end
    end
  end

  desc 'Run seed'
  task :seed do
    on roles(:app) do
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :rails, 'db:seed'
        end
      end
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
end


