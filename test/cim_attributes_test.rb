require 'test/unit'

unless ARGV.include?('gem')
  $:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
end
require 'cim_attributes'

class DB
  include CIMAttributes

  cim_attr_accessor :connection

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

class Connection

  def initialize(what_to_return)
    @what_to_return = what_to_return
  end

  def run(q)
    @what_to_return
  end

end


class CIMAttributesTest < Test::Unit::TestCase

  def test_01_globally_shared
    c = Connection.new('global')

    assert_nil DB.connection
    assert_nil LocalDB.connection
    assert_nil RemoteDB.connection

    assert_nil DB.new.connection
    assert_nil LocalDB.new.connection
    assert_nil RemoteDB.new.connection

    DB.connection = c

    assert_equal c, DB.connection
    assert_equal c, LocalDB.connection
    assert_equal c, RemoteDB.connection

    assert_equal c, DB.new.connection
    assert_equal c, LocalDB.new.connection
    assert_equal c, RemoteDB.new.connection

    c2 = Connection.new('another global')

    DB.connection = c2

    assert_equal c2, DB.connection
    assert_equal c2, LocalDB.connection
    assert_equal c2, RemoteDB.connection

    assert_equal c2, DB.new.connection
    assert_equal c2, LocalDB.new.connection
    assert_equal c2, RemoteDB.new.connection

  end

  def test_02_class_shared
    c = Connection.new('global')
    lc = Connection.new('local')
    rc = Connection.new('remote')

    #clean up form previous test
    DB.connection = nil

    assert_nil DB.connection
    assert_nil LocalDB.connection
    assert_nil RemoteDB.connection

    assert_nil DB.new.connection
    assert_nil LocalDB.new.connection
    assert_nil RemoteDB.new.connection

    DB.connection = c
    LocalDB.connection = lc

    assert_equal c, DB.connection
    assert_equal lc, LocalDB.connection
    assert_equal c, RemoteDB.connection

    assert_equal c, DB.new.connection
    assert_equal lc, LocalDB.new.connection
    assert_equal c, RemoteDB.new.connection

    RemoteDB.connection = rc

    assert_equal c, DB.connection
    assert_equal lc, LocalDB.connection
    assert_equal rc, RemoteDB.connection

    assert_equal c, DB.new.connection
    assert_equal lc, LocalDB.new.connection
    assert_equal rc, RemoteDB.new.connection

  end

  def test_03_instance_shared
    c = Connection.new('global')
    lc = Connection.new('local')
    rc = Connection.new('remote')
    lci = Connection.new('local instance')
    rci = Connection.new('remote instance')

    #clean up form previous test
    DB.connection = nil
    LocalDB.connection = nil
    RemoteDB.connection = nil

    assert_nil DB.connection
    assert_nil LocalDB.connection
    assert_nil RemoteDB.connection

    assert_nil DB.new.connection
    assert_nil LocalDB.new.connection
    assert_nil RemoteDB.new.connection

    DB.connection = c
    LocalDB.connection = lc

    ldb = LocalDB.new
    assert_equal lc, ldb.connection
    ldb.connection = lci
    assert_equal lci, ldb.connection

    rdb = RemoteDB.new
    assert_equal c, rdb.connection

    RemoteDB.connection = rc
    assert_equal rc, rdb.connection

    rdb.connection = rci
    assert_equal rci, rdb.connection

    assert_equal rc, RemoteDB.connection
    assert_equal rc, RemoteDB.new.connection

    rdb.connection = nil
    assert_equal rc, rdb.connection

    RemoteDB.connection = nil
    DB.connection = nil

    assert_raises RuntimeError do
      rdb.ensure_connection!
    end

  end

  def test_04_method_specific
    #clean up form previous test
    DB.connection = nil
    LocalDB.connection = nil

    assert_nil DB.connection
    assert_nil LocalDB.connection
    
    assert_nil DB.new.connection
    assert_nil LocalDB.new.connection

    c = Connection.new('global')
    lc = Connection.new('local')
    lcm = Connection.new('local method')

    DB.connection = c

    assert_equal 'global', DB.query('blah')
    assert_equal 'global', LocalDB.query('blah')

    LocalDB.connection = lc
    assert_equal 'local method', LocalDB.query('blah', lcm)
    assert_equal 'global', DB.query('blah')
    assert_equal 'local', LocalDB.query('blah')

    DB.connection = LocalDB.connection = nil
    assert_equal 'local method', LocalDB.query('blah', lcm)
    assert_raises RuntimeError do
      assert_equal 'local method', LocalDB.query('blah')
    end
    

  end

end
