# Rakefile for rake        -*- ruby -*-

# Copyright 2003, 2004, 2005 by Jim Weirich (jim@weirichhouse.org)
# All rights reserved.

# This file may be distributed under an MIT style license.  See
# MIT-LICENSE for details.

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rdoc/task'

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.verbose = true
  t.test_files = FileList['test/**/test_*.rb']
end

RDoc::Task.new do |doc|
  doc.main   = 'README.rdoc'
  doc.title  = 'Rake -- Ruby Make'
  doc.rdoc_files = FileList.new %w[lib MIT-LICENSE doc/**/*.rdoc *.rdoc]
  doc.rdoc_dir = 'html'
end

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = %w(--color)
end

task :default => :spec
