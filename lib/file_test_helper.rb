require 'tmpdir'

module FileTestHelper
  include FileUtils

  #Specify the files you need to create in a hash.
  #The keys of the hash represent the file path and the value represents it's content.
  #Examples:
  #* {'a dir/a file' => 'content'} creates the 'a dir' directory containing an 'a file' file which content is 'content'.
  #* {'another dir/' => ''} creates an empty 'another dir' directory. The value must be an empty string.
  #Optionally you can specify a different base directory (other than the default tmp) to use as a base directory.
  #Example:
  #* 'stylesheets', 'file.txt' => "" will create the file.txt file inside the existent stylesheets directory. The stylesheets directory won't be deleted
  def with_files(files_with_contents = {})
    with_files_in_directory(nil, files_with_contents) do
      yield
    end
  end

  def with_files_in_directory(base_dir, files_with_contents)
    initial_directory = current_directory
    raise ArgumentError, "The base directory '#{base_dir}' does not exist." if base_dir && !File.exist?(base_dir)
    working_directory = base_dir || create_working_directory

    begin
      create_files_in_working_directory(working_directory, files_with_contents)
      yield
    ensure
      cd initial_directory
      if base_dir.nil?
        remove_dir(working_directory) if File.exist?(working_directory)
      else
        remove_files(base_dir, files_with_contents)
      end
    end
  end

  private
  def current_directory
    Dir.pwd
  end

  def create_working_directory
    working_directory = File.join(Dir.tmpdir, "__test_dir__#{Process.pid}")
    mkpath(working_directory)
    return working_directory 
  end

  def create_files_in_working_directory(working_directory, files_with_contents)
    cd working_directory

    return unless files_with_contents
    files_with_contents.each do |path, file_contents|
      raise ArgumentError, 'A path is not allowed to start with /' if path =~ /^\//
      raise ArgumentError, 'A path is not allowed to contain ..' if path =~ /\.\./

      dir, file = path.scan(/(.*[\/])?([^\/]*$)/)[0] 
      mkpath dir unless(dir.nil? or dir.empty?)

      unless(file.nil? or file.empty?)
        File.open(path, 'w') do |f|
          f << file_contents unless file_contents == nil
        end
      else
        raise ArgumentError, 'File content can only be set to files' unless file_contents.nil? or file_contents.empty?
      end
    end    
  end

  def remove_files(base_dir, files_with_contents)
    initial_dir = Dir.pwd
    cd base_dir
    begin
      files_with_contents.each do |path, file_contents|
        remove_dir(path.split(File::SEPARATOR).first)
      end
    ensure
      cd initial_dir
    end
  end
end
