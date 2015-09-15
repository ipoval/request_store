require "request_store/version"
require "request_store/middleware"
require "request_store/railtie" if defined?(Rails::Railtie)

module RequestStore
  def self.store
    Thread.current[:request_store] ||= {}
  end

  def self.clear!
    Thread.current[:request_store] = {}
  end

  def self.read(key)
    store[key]
  end

  def self.write(key, value)
    store[key] = value
  end

  class << self
    alias_method :[], :read
    alias_method :[]=, :write
  end

  def self.exist?(key)
    store.key?(key)
  end

  def self.fetch(key, &block)
    store[key] = yield unless exist?(key)
    store[key]
  end

  def self.delete(key, &block)
    store.delete(key, &block)
  end
end
