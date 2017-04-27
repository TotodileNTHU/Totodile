# omitted earlier code
require 'rake/testtask'

task :default do
  puts `rake -T`
end

Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
  t.warning = false
end

namespace :db do
  require 'sequel'
  Sequel.extension :migration
  desc 'Run migrations'
  task :migrate do
    require 'sequel'
    require_relative 'init'
    puts 'Migrating database to latest'
    Sequel::Migrator.run(DB, 'db/migrations')
  end
  desc 'Rollback database to specified target'
  # e.g. $ rake db:rollback[100]
  task :rollback, [:target] do |_, args|
    target = args[:target] ? args[:target] : 0
    puts "Rolling back database to #{target}"
    Sequel::Migrator.run(DB, 'db/migrations', target: target)
end
  desc 'Perform migration reset (full rollback and migration)'
  task reset: [:rollback, :migrate]
end

namespace :spec do 
  desc 'run all the spec'
  task all: [:clear, :account, :posting]

  task :clear do
    puts '******* clear database *******'
    sh "ruby spec/clean_db.rb"
  end

  task :account do
    puts '******* run account spec *******'
    sh "ruby spec/account_spec.rb"
  end

  task :posting do
    puts '******* run posting spec *******'
    sh "ruby spec/posting_spec.rb"
  end
end