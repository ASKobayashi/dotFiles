require 'rubygems'
require 'pp'
require 'irb/completion'

IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:AUTO_INDENT]=true

alias q exit

# Wirble
begin
  # load wirble
  require 'wirble'

  # start wirble (with color)
  Wirble.init
  Wirble.colorize
rescue LoadError => err
  warn "Couldn't load Wirble: #{err}"
end

# Easily print methods local to an object's class
class Object
  def local_methods
    (methods - Object.instance_methods).sort
  end

  # print documentation
  #
  #   ri 'Array#pop'
  #   Array.ri
  #   Array.ri :pop
  #   arr.ri :pop
  def ri(method = nil)
    unless method && method =~ /^[A-Z]/ # if class isn't specified
      klass = self.kind_of?(Class) ? name : self.class.name
      method = [klass, method].compact.join('#')
    end
    puts `ri '#{method}'`
  end
end

#load Rails Stuff
if ENV['RAILS_ENV'] or defined?(Rails)
  def change_log(stream)
    ActiveRecord::Base.logger = Logger.new(stream)
    ActiveRecord::Base.clear_active_connections!
  end

  def show_log
    change_log(STDOUT)
  end

  def hide_log
    change_log(nil)
  end

  def show_session(session)
    Marshal.load(Base64.decode64(session))
  end

  change_log(STDOUT)

  # Test helper
  if Rails.env == 'test'
    require 'test/test_helper'
  end

  def show(obj)
    y(obj.send("column_names"))
  end
end
