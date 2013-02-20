# == Schema Information
#
# Table name: scripts
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  param       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  command     :text
#  description :text
#

class Script < ActiveRecord::Base
  attr_accessible :name, :description, :command, :param
  validates :name, 
            :presence => true, 
            :uniqueness => true,
            :format => { :with => /^[^`!@#\$%\^&*+=]+$/,
                         :message => "No speacial characters allowed" 
                       }

def self.to_csv(options = {})
  CSV.generate(options) do |csv|
column_names =    ["id", "name", "description", "command"]
 csv << column_names
    all.each do |script|
      csv << script.attributes.values_at(*column_names)
    end
  end
end

end
