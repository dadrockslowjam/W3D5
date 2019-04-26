require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    # ...
    return @cols unless @cols.nil?
      

    @cols = []
    
    columns_arr = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL

    columns_arr.first.each do |column|
      @cols << column.to_sym
    end

    @cols

  end

  def self.finalize!
   self.columns.each do |col|

      define_method(col) do
        # self.instance_variable_get("@#{col}")
        self.attributes[col]
      end

      define_method("#{col}=") do |value|
        # self.instance_variable_set("@#{col}", value)
        self.attributes[col] = value
      end

    end

  end

  def self.table_name=(table_name)
    # ...
    @table_name = table_name
  end

  def self.table_name
    # ...
    @table_name ||= self.name.downcase.pluralize
  end

  def self.all
    # ...
    results = DBConnection.execute(<<-SQL, table_name)
     SELECT
       *
      FROM
        #{table_name}
    
    SQL
    parse_all(results)
  end

  def self.parse_all(results)
    # ...
   results.map {|result| self.new(result)}
    
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    # ...
    params.each do |attr_name, value|
      raise "unknown attribute '#{attr_name}'" unless self.class.columns.include?(attr_name)
      # attributes[attr_name] = value
      self.send("#{attr_name}=", value)
    end
  end

  def attributes
    # ...
    @attributes ||= {}
  end

  def attribute_values
    # ...
    self.attributes.values
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
