class MethodExecuter
	
  def executing_method_stack
    @executing_method_stack ||= Array.new
  end

  def current_executing_method
    executing_method_stack.last
  end

  def execute(instance, method, args)
    begin
      self.executing_method_stack.push method
      instance.instance_exec(*args, &method.block)
    ensure
      self.executing_method_stack.pop
    end
  end

end