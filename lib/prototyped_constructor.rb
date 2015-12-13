class PrototypedConstructor

  def self.new(prototyped_obj)
    OfPrototypedObjConstructor.new(prototyped_obj)
  end

  def self.copy(obj)
    CopyConstructor.new(obj)
  end

end
