class PrototypeMethod

  attr_accessor :name, :block, :prototype

  def initialize(name, block, prototype)
    @name = name
    @block = block
    @prototype = prototype
  end

end