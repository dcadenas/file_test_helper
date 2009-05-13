# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{filetesthelper}
  s.version = "0.10.0"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Daniel Cadenas Ni\303\263n"]
  s.autorequire = %q{filetesthelper}
  s.date = %q{2009-05-12}
  s.description = %q{A simple helper aimed at reducing the setup effort needed to create directories, files and file content in integration test cases.}
  s.email = %q{dcadenas@gmail.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["Rakefile.rb", "README.rdoc", "VERSION.yml", "lib/filetesthelper.rb", "spec/FileTestHelper_spec.rb", "spec/spec.opts", "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://rubyforge.org/projects/filetesthelper/}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A simple helper aimed at reducing the setup effort needed to create directories, files and file content in integration test cases.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
