# -*- encoding: utf-8 -*-

$:.unshift File.expand_path('../lib', __FILE__)
require 'cim_attributes'

Gem::Specification.new do |s|
  s.name = 'cim_attributes'
  s.version = CIMAttributes::VERSION

  s.authors = ['Ben Lund']  
  s.description = 'Ruby module to have shared or distinct attributes among classes, sub-classes, instances and methods'
  s.summary = 'Like attr_accessor, cattr_accessor, class_inheritable_accessor, but allows you to set the attribute for all instances, or just instances of a sub-class, or just a particular instance.'
  s.email = 'ben@benlund.com'
  s.homepage = 'http://github.com/benlund/cim_attributes'

  s.files = ['lib/cim_attributes.rb']
end
