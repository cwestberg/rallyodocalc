class LogEntry < NSManagedObject
  def self.entity
    @entity ||= begin
      entity = NSEntityDescription.alloc.init
      entity.name = 'LogEntry'
      entity.managedObjectClassName = 'LogEntry'
      entity.properties = 
        ['creation_date', NSDateAttributeType,
         'coordinate', NSStringAttributeType,
         'action', NSStringAttributeType,
         'split', NSStringAttributeType].each_slice(2).map do |name, type|
            property = NSAttributeDescription.alloc.init
            property.name = name
            property.attributeType = type
            property.optional = false
            property
          end
      entity
    end
  end 
end