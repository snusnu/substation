# encoding: utf-8

require 'rubygems'
require 'rake'
require 'devtools'

Devtools.init

FileList['tasks/**/*.rake'].each { |task| import task }

desc 'Default: run all specs'
task :default => :spec
