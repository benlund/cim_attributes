# CIM Attributes

A Ruby module for declaring attributes of classes and instances that can be shared or distinct between sub-classes, instances and even method calls.  Like attr_accessor, cattr_accessor, class_inheritable_accessor, but allows you to set the attribute for all instances, or just instances of a sub-class, or just a particular instance.

## Install

    $ sudo gem install cim_attributes

## Summary

    class DB
      include CIMAttributes
    
      cim_attr_accessor :connection ## creates DB.connection, DB.connection=, DB.with_connection, DB#connection, DB#connection=
    
      def self.query(q, connection=nil)
        with_connection(connection) do |c|
          c.run(q)
        end
      end
    
    end
    
    class LocalDB < DB
    end
    
    class RemoteDB < DB
    end

    DB.connection #=> nil
    LocalDB.connection #=> nil
    RemoteDB.connection #=> nil
    
    c = "connect:to:global"

    DB.connection = c

    DB.connection #=> "connect:to:global"
    LocalDB.connection #=> "connect:to:global"
    RemoteDB.connection #=> "connect:to:global"
    
    db = DB.new

    db.connection  #=> "connect:to:global"
    
    db.connection =  "connect:to:instance"
    
    db.connection  #=> "connect:to:instance"

    DB.new.connection  #=> "connect:to:global"

    LocalDB.connection #=> "connect:to:global"
    RemoteDB.connection #=> "connect:to:global"

    LocalDB.connection = "connect:to:local"

    LocalDB.connection #=> "connect:to:local"
    RemoteDB.connection #=> "connect:to:global"

    LocalDB.query("some query") ## runs using "connect:to:local" 
    LocalDB.query("some query", "connect:to:global") ## runs using "connect:to:global"


## Generated Methods

### Klass.attribute

Returns the currently set class instance variable @attribute for this class. If it is nil, calls the attribute method on its superclass (if implemented).

### Klass.attribute=

Sets the class instance variable @attribute for this class.

### Klass.with_attribute(val=nil, &block)

Calls the block with val, or if val is nil, with Klass.attribute.  This allows you to write class methods that can take an optional argument to override the pre-set attribute for the duration of that method call.

### Klass#attribute

Returns the currently set instance variable @attribute. If it is nil, calls Klass.attribute (which will cascade up the class hierarchy as necessary).

### Klass#attribute=

Sets the instance variable @attribute for this instance.


## Useful for

  * Sharing a logger between classes and instances
  * Sharing network connections
  * Probably lots of other things I haven't used it for yet

