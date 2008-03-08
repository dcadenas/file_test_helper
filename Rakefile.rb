require 'rubygems'
require 'rubygems/gem_runner'
require 'rake'
require "rake/clean"
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'spec/rake/spectask'

NAME = 'filetesthelper'
PKGVERSION = '1.0.0'
is_windows = (PLATFORM =~ /win32|cygwin/)
SUDO = is_windows ? '' : 'sudo'
README = "README.txt"


##############################################################################
# Packaging & Installation
##############################################################################

CLEAN.include ["pkg", "coverage", "doc"]

spec = Gem::Specification.new do |s| 
  s.name = NAME
  s.version = PKGVERSION
  s.author = "Daniel Cadenas"
  s.email = "dcadenas@gmail.com"
  s.homepage = "http://dcadenas.blogspot.com"
  s.platform = Gem::Platform::RUBY
  s.summary = "A simple helper aimed at reducing the setup effort needed to create directories, files and file content in integration test cases."
  s.description = s.summary
  s.files = Dir["{spec,lib}/**/*"] + [README, "Rakefile.rb"]
  s.has_rdoc = true
  s.extra_rdoc_files = [README]
  s.require_path = 'lib'
  s.autorequire = NAME
#  s.require_paths << ['lib']
end

Rake::GemPackageTask.new(spec) do |pkg| 
  pkg.gem_spec = spec
end 

desc "Run :package and install the resulting .gem"
task :install => [:clean, :specs_with_rcov, :rdoc, :package] do
  Gem::GemRunner.new.run(['install', "pkg/#{NAME}-#{PKGVERSION}.gem", '--no-rdoc', '--no-ri'])
end

desc "Run :clean and uninstall the .gem"
task :uninstall => :clean do
  Gem::GemRunner.new.run(['uninstall', NAME])
end


##############################################################################
# rSpec & rcov
##############################################################################

Spec::Rake::SpecTask.new('specs_with_rcov') do |t|
  t.ruby_opts << '-rubygems'
  t.spec_files = Dir['spec/**/*_spec.rb']
  t.spec_opts = ['--options', 'spec/spec.opts']
  t.rcov = true
  t.rcov_opts = ['--text-summary']
end


##############################################################################
# Documentation
##############################################################################

Rake::RDocTask.new(:rdoc) do |rd|  
  rd.rdoc_files = [README] + Dir['lib/**/*']
  rd.rdoc_dir = 'doc' 
  rd.title    = NAME
  rd.options << "-SNm#{README}"
end

task :default => [:specs_with_rcov, :rdoc]
