require 'tmpdir'

module FileTestHelper
  include FileUtils
  
  #Specify the files you need to create in a hash.
  #The keys of the hash represent the file path and the value represents it's content.
  #Examples:
  #* {'a dir/a file' => 'content'} creates the 'a dir' directory containing an 'a file' file which content is 'content'.
  #* {'another dir/' => ''} creates an empty 'another dir' directory. The value must be an empty string.
  def with_files(files_with_contents = {})
    begin
      initial_directory = current_directory()
      working_directory = create_working_directory()
      create_files_in_working_directory(working_directory, files_with_contents)
      yield
    ensure
      cd initial_directory
      remove_dir(working_directory) if File.exist?(working_directory)
    end
  end

  private
  def current_directory
    Dir.pwd
  end
  
  def create_working_directory
    process_id = $$
    working_directory = File.join(Dir.tmpdir, "__test_dir__#{process_id}")
    mkpath working_directory
    return working_directory 
  end
  
  def create_files_in_working_directory(working_directory, files_with_contents)
    cd working_directory
    files_with_contents.each do |path, file_contents|
      fail 'A path is not allowed to start with /' if path =~ /^\//
      fail 'A path is not allowed to contain ..' if path =~ /\.\./
      
      dir, file = path.scan(/(.*[\/])?([^\/]*$)/)[0] 
      unless(dir.nil? or dir.empty?)
        mkpath dir
      end
      
      unless(file.nil? or file.empty?)
        File.open(path, 'w') do |f|
          f << file_contents unless file_contents == nil
        end
      else
        fail 'File content can only be set to files' unless file_contents.nil? or file_contents.empty?
      end
    end    
  end
end