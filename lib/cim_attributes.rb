module CIMAttributes

  module ClassMethods

    def cim_attr_reader(*args)
      raise ArgumentError, 'no args for cim_attr_reader' unless args.size > 0
      opts = if args.last.is_a?(Hash)
               args.pop
             else
               {}
             end
      args.each do |attr|

        ## class methods

        target, message = *(if self.respond_to? :define_singleton_method
                              [self, :define_singleton_method]
                            else
                              [class << self; self; end, :define_method]
                            end)

        target.send message, attr do 
          self.instance_variable_get("@#{attr}") || if self.superclass.respond_to?(attr)
                                                      self.superclass.send(attr)
                                                    else
                                                      nil
                                                    end
        end

        target.send message, "#{attr}=" do |val|
          self.instance_variable_set("@#{attr}", val)
        end

        target.send message, "with_#{attr}" do |val, &blk|
          if val || (val = self.send(attr))
            blk.call(val)
          else
            raise("no #{attr} defined for #{self} and none passed in")
          end
        end

        ## instance methods

        self.send :define_method, attr do
          self.instance_variable_get("@#{attr}") || self.class.send(attr)
        end

        self.send :define_method, "#{attr}=" do |val|
          self.instance_variable_set("@#{attr}", val)
        end

        self.send :define_method, "ensure_#{attr}!" do
          if !self.send(attr)
            raise("no #{attr} defined for #{self}")
          end
        end
      end
    end

    def cim_attr_writer(*args)
      raise ArgumentError, 'no args for cim_attr_writer' unless args.size > 0
      opts = if args.last.is_a?(Hash)
               args.pop
             else
               {}
             end
    end

    def cim_attr_accessor(*args)
      raise ArgumentError, 'no args for cim_attr_accessor' unless args.size > 0
      cim_attr_reader(*args)
      cim_attr_writer(*args)
    end

  end

  def self.included(base)
    base.extend(ClassMethods)
  end

end
