#!/usr/bin/env puma

directory '/home/deploy/chess-erp'
rackup "/home/deploy/chess-erp/current/config.ru"
environment 'staging'

tag ''

pidfile "/home/deploy/chess-erp/shared/tmp/pids/puma.pid"
state_path "/home/deploy/chess-erp/shared/tmp/pids/puma.state"
stdout_redirect '/home/deploy/chess-erp/shared/log/puma_access.log', '/home/deploy/chess-erp/shared/log/puma_error.log', true

threads 0,16

bind 'unix:///home/deploy/chess-erp/shared/tmp/sockets/chess-erp-puma.sock'

workers 0

prune_bundler

on_restart do
  puts 'Refreshing Gemfile'
  ENV["BUNDLE_GEMFILE"] = "/home/deploy/chess-erp/current/Gemfile"
end
