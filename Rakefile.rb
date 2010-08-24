# coding: utf-8
require 'rubygems'
require 'rubygems/gem_runner'
require 'rake'
require "rake/clean"
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'spec/rake/spectask'
 
begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "filetesthelper"
    gemspec.summary = "A simple helper aimed at reducing the setup effort needed to create directories, files and file content in integration test cases."
    gemspec.email = "dcadenas@gmail.com"
    gemspec.homepage = "http://rubyforge.org/projects/filetesthelper/"
    gemspec.description = gemspec.summary
    gemspec.authors = ["Daniel Cadenas Nión"]
    gemspec.version = '1.0.1'
    gemspec.platform = Gem::Platform::RUBY
  #gemspec.files = Dir["{spec,lib}/**/*"] + [README, "Rakefile.rb"]
    gemspec.require_path = 'lib'
    gemspec.autorequire = gemspec.name
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end


Spec::Rake::SpecTask.new('specs_with_rcov') do |t|
  t.ruby_opts << '-rubygems'
  t.spec_files = Dir['spec/**/*_spec.rb']
  t.spec_opts = ['--options', 'spec/spec.opts']
  t.rcov = true
  t.rcov_opts = ['--text-summary']
end

task :default => [:specs_with_rcov]
