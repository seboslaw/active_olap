module ActiveOLAP
  
  class Configurator
    
    # initializes a OLAP::Configurator object, which is used in the block 
    # passed to the call enable_active_olap. It can be used to register
    # dimensions and classes
    def initialize(klass)
      @klass = klass
    end
    
    # registers a dimension for the class it belongs to
    def dimension(name, definition = nil)
      if definition.is_a?(Hash)
        definition[:name] = name
      end
      definition = name.to_sym if definition.nil?
      @klass.active_olap_dimensions[name] = definition
    end
    
    def time_dimension(name, field, defaults = {})
      @klass.active_olap_dimensions[name] = Proc.new do |*options|
        options = options.empty? ? {} : options.first
        { :trend => defaults.merge(options).merge(:timestamp_field => field) }
      end
    end
    
    # registers an aggregate for the class it belongs to
    def aggregate(name, definition = nil, options = {})
      definition = name if definition.nil?
      agg_definition = options.merge(:expression => definition)
      @klass.active_olap_aggregates[name] = agg_definition
    end
  end
end