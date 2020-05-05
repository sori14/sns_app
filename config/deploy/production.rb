# EC2サーバーのIP、EC2サーバーにログインするユーザー名、サーバーのロールを記述
server '18.177.96.5', user: 'sorimachi', roles: %w{app web}

#デプロイするサーバーにsshログインする鍵の情報を記述
set :ssh_options, keys: '~/.ssh/sns_key2_rsa'
