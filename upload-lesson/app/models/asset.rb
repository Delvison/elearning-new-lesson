#This class was made so that a Lesson can have multiple attachments
#Essentially, each Asset is really just an attachment
class Asset < ActiveRecord::Base
  attr_accessible :lesson_id, :attachment

#allows us to use :lesson_id in the :url
Paperclip.interpolates :lesson_id do |attachment, style|
    attachment.instance.lesson_id
    end

  has_attached_file :attachment,
 :url => "/attachments/:lesson_id/:basename.:extension",
 :path => ":rails_root/public/attachments/lessons/:lesson_id/:basename.:extension", :dependent => :destroy
 
#an asset should not exist without an attachment
 validates_attachment_presence :attachment

end
