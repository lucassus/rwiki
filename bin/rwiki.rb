#!/usr/bin/env ruby
# encoding: utf-8

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rwiki'

ROOT_PATH = File.dirname(__FILE__) + '/../test/fixtures/pages'
Rwiki::App.run!
