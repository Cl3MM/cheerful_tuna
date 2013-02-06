# encoding: UTF-8
class Document < ActiveRecord::Base

  belongs_to  :owner, polymorphic: true, inverse_of: :subscriptions
  attr_accessible :nice_file, :owner_id, :owner_type,
                  :designation

  #set up "uploaded_file" field as attached_file (using Paperclip)
  has_attached_file :nice_file, url: "/documents/get/:id",
                    path: ":rails_root/tmp/paperclip/:id/:style/:basename.:extension"
                    #:path => ":rails_root/public/system/:owner_id/:id/:basename.:extension"
  validates_attachment_size :nice_file, :less_than => 10.megabytes
  validates_attachment_presence :nice_file

  def rename_file new_file_name
    debug [ "Renaming file" ]
    (record.nice_file.styles.keys+[:original]).each do |style|
      path = record.nice_file.path(style)
      FileUtils.move(path, File.join(File.dirname(path), new_file_name))
    end
    record.update_attribute( :nice_file_file_name, new_file_name)
  end

  def file_extension
    File.extname(nice_file_file_name).gsub(".","")
  end

  def file_name
    nice_file_file_name
  end

end
