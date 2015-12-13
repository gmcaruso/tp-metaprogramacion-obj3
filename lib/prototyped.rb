#!/usr/bin/env ruby
# encoding: utf-8
require_relative 'method_executer'
require_relative 'prototype_method'

module Prototyped

  def set_method name, block
    prototyped_methods[name] = PrototypeMethod.new(name, block, self)
  end

  def set_property(name, value)
    # 
    self.instance_variable_set("@#{name}", value)
    # 
    self.set_method(name, proc {
      self.instance_variable_get("@#{name}")
    })

    self.set_method("#{name}=".to_sym, proc { |new_value|
      set_method(name, new_value) if new_value.kind_of?(Proc) 
      self.instance_variable_set("@#{name}", new_value)
    })
  end

  def set_prototypes(prototypes_array)
    prototypes_list.clear
    prototypes_array.reverse.each do |parent|
      prototypes_list.push(parent)
    end
  end

  def method_missing method_name, *args, &block

    method = get_method method_name

    if(method)
      result = method_executer.execute(self, method, args)
    else
      name = method_name.to_s
      super if !name.end_with?("=") && !block_given?
      value = args[0] || block
      super unless value
      name = name.gsub('=', '')
      self.set(name, value)
    end

    result
  end

  def set_prototype prototype
    prototypes_list.clear
    prototypes_list.push(prototype)
  end

  def get_method(name)
    prototyped_methods[name.to_sym] || get_prototype_method(name)
  end

  def prototyped_methods
    @methods ||= Hash.new
  end

  def prototypes_list
    @prototypes_list ||= Array.new
  end

  def method_executer
    @method_executer ||= MethodExecuter.new
  end



  def get_prototype_method(name)
    method = nil
    prototypes_list.each do |parent|
      method = parent.get_method name
      break if method
    end

    method
  end
end


