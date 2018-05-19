#!/usr/bin/env ruby

require 'rubygems'
require 'bundler'
Bundler.require

require_relative 'command_runner/command'

CommandRunner::Command.run ARGV
