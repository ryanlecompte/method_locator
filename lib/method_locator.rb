require "method_locator/version"

# MethodLocator finds all method definitions in an object instance, class, or
# module ancestor chain. This code will make more sense if you understand Ruby's
# object model and method lookup path. See README for more information.
module MethodLocator
  def methods_for(meth)
    method_lookup_path.each_with_object([]) do |clazz, matches|
      matches << clazz.instance_method(meth) if instance_methods_for(clazz).include?(meth)
    end
  end

  def method_lookup_path
    lookup_path = is_a?(Class) ? class_lookup_path : nonclass_lookup_path
    insert_modules_into(lookup_path)
  end

  def only_class_ancestors
    ancestors.grep(Class)
  end

  private

  def instance_methods_for(clazz)
    clazz.instance_methods(false) + clazz.private_instance_methods(false)
  end

  def nonclass_lookup_path
    # not only non-classes have singleton classes, for example integers
    sclass = singleton_class rescue nil
    self.class.only_class_ancestors.unshift(sclass).compact
  end

  def class_lookup_path
    only_class_ancestors.map(&:singleton_class) + Class.only_class_ancestors
  end

  def insert_modules_into(lookup_path)
    # reverse is used here since included_modules contains all modules defined in
    # the current class as well as in its ancestors.
    lookup_path.reverse.map do |clazz|
      [clazz.included_modules.reverse, clazz]
    end.flatten.uniq.reverse
  end
end

Object.send(:include, MethodLocator)
