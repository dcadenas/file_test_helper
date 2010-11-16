# coding: utf-8
require 'rubygems'
require 'rubygems/gem_runner'
require 'rake'
require "rake/clean"
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'spec/rake/spectask'

Spec::Rake::SpecTask.new('specs_with_rcov') do |t|
  t.ruby_opts << '-rubygems'
  t.spec_files = Dir['spec/**/*_spec.rb']
  t.spec_opts = ['--options', 'spec/spec.opts']
  t.rcov = true
  t.rcov_opts = ['--text-summary']
end

task :default => [:specs_with_rcov]
