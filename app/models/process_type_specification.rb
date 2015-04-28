class ProcessTypeSpecification < ActiveRecord::Base
  attr_accessible :process_type_id, :specification_id
  belongs_to :process_type
  belongs_to :specification
end
