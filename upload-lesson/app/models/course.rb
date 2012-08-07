require 'zip/zip'
require 'zip/zipfilesystem'

class Course < ActiveRecord::Base
  attr_accessible :description, :name, :subject, :lessons_attributes
  has_many :lessons, :dependent => :destroy
  accepts_nested_attributes_for :lessons
   
  validates_presence_of :name, :subject, :description
  validates_uniqueness_of :name

  def bundle
   t = self
   bundle_filename = "public/attachments/courses/#{t.name}.zip"
   FileUtils.rm "public/attachments/courses/#{t.name}.zip", :force => true #remove the zip in case it already exists
   dir = "public/attachments/lessons" #location of the lesson directories

   Zip::ZipFile.open(bundle_filename,Zip::ZipFile::CREATE){
	   |zipfile|
     Dir.foreach(dir) do |item| #for every lesson directory in (dir), do the following..
	if (!item.eql?(".") && !item.eql?("..")) #we want to skip these directories
	  les = Lesson.find(item) #find the lesson object that is associated with |item|
	  les.bundle #ensures all files are up-to-date in the zips
	    if (les.course_id.eql? t.id) #if the lessons course_id equals the current Course ID then do the following:
		   item_path = "#{dir}/#{item}/#{t.name}_#{les.title}.zip"
		   thefile = "#{t.name}_#{les.title}.zip"
		   zipfile.add(thefile,item_path) if File.file? item_path
	     end #ends if
	 end #ends if
      end #ends Dir.foreach block     
   } #ends Zip::ZipFile block
     File.chmod(0644, bundle_filename) #change file permissions
     self.save
  end #end of bundle method

  def downloadcourse
    send_file "/public/attachments/courses/#{self.name}.zip", :type=>"application/zip" 
  end
end
