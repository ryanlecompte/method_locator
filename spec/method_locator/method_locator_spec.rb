require 'spec_helper'


describe MethodLocator do

  describe "#methods_for" do
    it "returns proper methods for regular object instances" do
      instance = B.new
      instance.extend(M5)

      def instance.foo
      end

      instance.methods_for(:foo).map(&:owner).should == [instance.singleton_class,
                                                         M5,
                                                         B,
                                                         M2,
                                                         M1,
                                                         A]
    end

    it "returns proper methods for classes" do
      B.methods_for(:blah).map(&:owner).should == [B.singleton_class, M3, A.singleton_class]
    end

    it "returns proper methods for modules" do
      M4.methods_for(:hello).map(&:owner).should == [M4.singleton_class]
    end

    it "returns proper methods for objects without a singleton class" do
      5.methods_for(:+).should == [Fixnum.instance_method(:+)]
    end
  end

  describe "#method_lookup_path" do
    it "returns proper path for regular object instances" do
      instance = B.new
      instance.extend(M5)

      method_lookup_path_for(instance).should == [instance.singleton_class,
                                                  M5,
                                                  B,
                                                  M2,
                                                  M1,
                                                  A,
                                                  Object,
                                                  MethodLocator,
                                                  Kernel,
                                                  BasicObject]
    end

    it "returns proper path for classes" do
      method_lookup_path_for(B).should == [B.singleton_class,
                                           M3,
                                           A.singleton_class,
                                           Object.singleton_class,
                                           BasicObject.singleton_class,
                                           Class,
                                           Module,
                                           Object,
                                           MethodLocator,
                                           Kernel,
                                           BasicObject]
    end

    it "returns proper path for modules" do
      method_lookup_path_for(M2).should == [M2.singleton_class,
                                            Module,
                                            Object,
                                            MethodLocator,
                                            Kernel,
                                            BasicObject]
    end

    it "returns proper path for objects without a singleton class" do
      5.method_lookup_path.should == 5.class.ancestors
    end
  end

  def method_lookup_path_for(obj)
    allowed_items = [obj, M1, M2, M3, M4, M5, A, B, Class, Module, Object, MethodLocator, Kernel, BasicObject]
    allowed_items = allowed_items + allowed_items.map(&:singleton_class)
    obj.method_lookup_path.keep_if { |c| allowed_items.include?(c) }
  end
end


module M1
  def foo
  end
end

module M2
  def foo
  end
end

module M3
  def blah
  end
end

module M4
  def self.hello
  end
end

module M5
  def foo
  end
end

class A
  def foo
  end

  def self.blah
  end
end

class B < A
  include M1
  include M2

  def foo
  end

  def self.blah
  end
end

B.extend(M3)
