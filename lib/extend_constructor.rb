class ExtendConstructor
  attr_accessor :properties_names
  attr_accessor :block

  def initialize(properties_names, &block)
    self.properties_names = properties_names
    self.block = block
  end

  def new *args
    args_cant = properties_names.arguments_needed
    first_args = args.first(args_cant)
    extended_args = args.last(args.size - args_cant)
    obj = properties_names.new *first_args

    if block.arity == extended_args.size
      obj.instance_exec(*extended_args, &block)
    else
      block.call(obj, *extended_args)
    end
    
    obj
  end

end
