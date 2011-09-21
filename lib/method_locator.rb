require "method_locator/version"

# MethodLocator finds all method definitions in an object instance, class, or
# module ancestor chain. This code will make more sense if you understand Ruby's
# object model and method lookup path. A great explanation of this can be found in:
# "Ruby's Eigenclasses Demystified" - http://blog.madebydna.com/all/code/2011/06/24/eigenclasses-demystified.html

module MethodLocator
  def methods_for(meth)
    method_lookup_path.each_with_object([]) do |clazz, matches|
      matches << clazz.instance_method(meth) if instance_methods_for(clazz).include?(meth)
    end
  end

  def method_lookup_path
    is_a?(Class) ? class_lookup_path : nonclass_lookup_path
  end

  private

  def nonclass_lookup_path
    self.class.ancestors.unshift(singleton_class)
  end

  def class_lookup_path
    lookup_path = ancestors.grep(Class).map(&:singleton_class) + Class.ancestors
    # reverse is used here since included_modules contains all modules defined in
    # the current class as well as in its ancestors.
    lookup_path.reverse.map do |clazz|
      [clazz.included_modules, clazz]
    end.flatten.uniq.reverse
  end

  def instance_methods_for(clazz)
    clazz.instance_methods(false) + clazz.private_instance_methods(false)
  end
end

Object.send(:include, MethodLocator)
