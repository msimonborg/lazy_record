example = File.expand_path('../../example', __FILE__)
$LOAD_PATH.unshift(example) unless $LOAD_PATH.include?(example)

require 'lazy_record'
autoload :Cat,    'cat'
autoload :Dog,    'dog'
autoload :Friend, 'friend'
autoload :Person, 'person'
