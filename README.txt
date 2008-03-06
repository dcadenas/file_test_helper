= FileTestHelper

A simple helper aimed at reducing the setup effort needed to create directories, files and file content in the scope of an integration test case.

== Example
  
  require 'filetesthelper'
  include FileTestHelper

  ...
  
  def test_some_code_that_uses_the_file_system
    #Let's say that the current directory here is X
    
    with_files('dir1/file1' => 'this is file1 content', 'dir1/file2' => 'this is file2 content') do
      #Now the current directory changed to Y which is a new directory
      #created under Dir.tmpdir containing only 'dir1/file1' and 'dir1/file2'.

      #Put some test code here.
    end
    
    #When we finish we are back at directory X and the Y directory is deleted with all its contents
  end

See the specs for more details.

