require File.dirname(__FILE__) + "/spec_helper"
require 'rubygems'
require 'spec'
require 'file_test_helper'
include FileTestHelper

describe FileTestHelper do
  parameters = {
    'nil' => nil,
    'an empty hash' => {},
    'a hash with only one file' => {'file.txt' => 'file content'}
  }

  parameters.each do |parameter_name, parameter|
    describe "when the hash paramater is #{parameter_name}" do
      it 'should execute the block parameter' do
        block_runned = false
        with_files(parameter) {block_runned = true}
        block_runned.should be_true
      end

      it 'should not use the current directory' do
        initial_directory = Dir.pwd
        with_files(parameter) do
          Dir.pwd.should_not == initial_directory
        end
        Dir.pwd.should == initial_directory
      end

      it 'should start in an empty working directory' do
        with_files(parameter) do
          Dir.glob('**/*').size == 0
        end
      end

      it 'should delete the working directory and its contents after running the block' do
        working_directory_path = ''
        with_files(parameter) do
          working_directory_path = Dir.pwd
        end
        working_directory_path.should_not be_empty
        File.exist?(working_directory_path).should be_false
      end
    end
  end

  it 'should create the files and directories that were specified in a hash' do
    files_to_create = {'a directory/a file.txt' => '', 'a directory/another file.rb' => '', 'an_empty_directory/' => '', 'a_file' => ''}
    with_files(files_to_create) do
      files_to_create.each_key{|created_file| File.exist?(created_file).should be_true}
    end
  end

  it 'should be possible to define the content of created files' do
    with_files('filea' => 'content of filea', 'fileb' => 'content of fileb') do
      File.read('filea').should == 'content of filea'
      File.read('fileb').should == 'content of fileb'
    end
  end

  it 'should interpret a path with an ending / as a directory' do
    with_files('this is a directory/another dir/' => '') do
      File.directory?('this is a directory/another dir').should be_true
    end    
  end

  it 'should throw an error if trying to set file content to a directory' do
    lambda { with_files('directory/' => 'imposible content, directories are not files') {}}.should raise_error
  end

  it 'should throw an error if a path which starts with the "/" character is specified' do
    lambda { with_files('/directory/filea' => 'content of filea') {}}.should raise_error
  end

  it 'should throw an error if a path uses ".."' do
    lambda { with_files('../../dir/filea' => 'content of filea') {}}.should raise_error
  end

  it 'should not throw an exception when the hash parameter is nil' do
    lambda { with_files(nil) {}}.should_not raise_error
  end

  describe "with base_dir" do
    it "should use the specified base dir instead of the default tmp dir" do
      initial_directory = Dir.pwd
      with_files_in_directory(initial_directory, 'somefile.txt' => '') do
        Dir.pwd.should == initial_directory
      end
      Dir.pwd.should == initial_directory
    end

    it "should not delete the base dir" do
      base_dir = FileUtils.mkpath("delete_this_dir")
      begin
        with_files_in_directory(base_dir, 'somefile.txt' => '') {}
        File.exist?(base_dir).should be_true
      ensure
        FileUtils.remove_dir(base_dir)
      end
    end

    it "should delete the created files" do
      with_files_in_directory(Dir.pwd, 'somefile.txt' => '') {}
      File.exist?('somefile.txt').should be_false
    end

    it "should throw an exception if the specified base dir doesn't exist" do
      lambda{
        with_files_in_directory('this_dir_does_not_exist', 'somefile.txt' => '') {}
      }.should raise_error(ArgumentError)
    end
  end
end
