# frozen_string_literal: true

# Copyright (c) 2017 M. Simon Borg
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'active_support'
require 'active_support/inflector'
require 'scoped_attr_accessor'

require 'lazy_record/version'
require 'lazy_record/associations'
require 'lazy_record/attributes'
require 'lazy_record/callbacks'
require 'lazy_record/class_methods'
require 'lazy_record/collections'
require 'lazy_record/dynamic_modules'
require 'lazy_record/methods'
require 'lazy_record/scopes'
require 'lazy_record/validations'
require 'lazy_record/relation'
require 'lazy_record/base_module'
require 'lazy_record/base'

# A collection of convenience methods for adding enhanced constructors,
# attributes, one-to-many collections, one-to-one associations, scopes,
# methods, and basic validations. Get a lot done with a little code.
#
# Inherit from LazyRecord::Base or include LazyRecord::BaseModule to
# unlock the features. The primary use case in mind is a toolkit
# for designing response objects for web API wrappers. Two
# other gems in progress that are using LazyRecord for this purpose are
# <tt>pyr</tt>(https://www.github.com/msimonborg/pyr) (Ruby interface
# for Phone Your Rep, a civic tool), and
# <tt>lapi</tt>(https://www.github.com/msimonborg/lapi), an API wrapper
# building tool with the goal of easing the construction of simple
# Ruby API wrappers.
#
# This library's API draws heavy inspiration from ActiveRecord.
module LazyRecord; end
