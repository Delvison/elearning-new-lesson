require 'zip/zip'
require 'zip/zipfilesystem'

class Lesson < ActiveRecord::Base
  attr_accessible :attachment, :course_id, :goal, :title, :assets_attributes
  belongs_to :course
  has_many :assets, :dependent => :destroy
  accepts_nested_attributes_for :assets, :reject_if => lambda { |a| a[:asset_file_name].blank? }


  def bundle
    t = Course.find(self.course_id)
#create the ZIPfile with the title of lesson_id
    bundle_filename = "public/attachments/lessons/#{self.id}/#{t.name}_#{self.title}.zip"
    FileUtils.rm "public/attachments/lessons/#{self.id}/#{t.name}_#{self.title}.zip", :force => true #remove in case it exists

     dir = "public/attachments/lessons/#{self.id}" #directory of the lesson
    
#open the ZIPfile in order to add items in
     Zip::ZipFile.open(bundle_filename, Zip::ZipFile::CREATE) {
       |zipfile|
       Dir.foreach(dir) do |item|
#for each "item" in the Dir, do the following..
        item_path = "#{dir}/#{item}"
         zipfile.add(item, item_path) if File.file? item_path
       end
      }
#change permissions on ZIPfile
  File.chmod(0644, bundle_filename)
  self.save
  end

  def download
    send_file "/public/attachments/lessons/#{self.id}/#{t.name}_#{self.title}.zip", :type=>"application/zip" 
  end
end


