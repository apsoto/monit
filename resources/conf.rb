actions :create, :delete

default_action :create

attribute :cookbook, :kind_of => String, :default => "monit"
attribute :depends, :kind_of => [String, Array]
attribute :group, :kind_of => [String, Array]
attribute :name, :name_attribute => true, :kind_of => String
attribute :path, :kind_of => String
attribute :pid, :kind_of => String
attribute :reload, :default => :delayed
attribute :rule, :kind_of => [String, Array] #TODO: regex check for if then
attribute :start, :kind_of => String
attribute :stop, :kind_of => String
attribute :template, :kind_of => String, :default => "conf.erb"
attribute :type, :equal_to => [:file, :process], :default => :process

def initialize(*args)
  super
  @action = :create
end

