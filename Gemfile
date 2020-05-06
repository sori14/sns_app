source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Rspecのコマンドの実行
gem 'spring-commands-rspec'
# エラーメッセージの日本語化
gem 'rails-i18n'

# Bootstrap4
gem 'bootstrap'
# jQuery(Bootstrapで必要)
gem 'jquery-rails'

# bcrypt
gem 'bcrypt', '3.1.11'

gem 'faker'

# ページネーション
gem 'will_paginate', '3.1.7'
gem 'will_paginate-bootstrap4'

# 画像投稿
gem 'carrierwave'
gem 'mini_magick'
gem 'fog'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2', '>= 5.2.2.1'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.4.4', '< 0.6.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Awesomeアイコン
gem 'font-awesome-sass'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # Rubyのコンソール
  gem 'pry-rails'
  # デバッカー
  gem 'pry-doc'    # methodを表示
  gem 'pry-byebug' # デバッグを実施(Ruby 2.0以降で動作する)
  gem 'pry-stack_explorer' # スタックをたどれる

  # IDEのデバッカー
  gem 'ruby-debug-ide'
  gem 'debase'

  # Capistrano
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  # Capistranoの追加gem
  gem 'ed25519'
  gem 'bcrypt_pbkdf'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'

  # Rspec
  gem 'rspec-rails'

  # FactoryBot(テストデータの生成ツール)
  gem 'factory_bot_rails'
  # テスト後にDBをクリアする
  gem 'database_cleaner'

  gem 'launchy'

  # assignsメソットの使用のため
  # コントローラー内のインスタンス変数にアクセスできる
  gem 'rails-controller-testing'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data'

# 本番環境で使用するAPサーバのunicorn
group :production, :staging do
  gem 'unicorn'
end

