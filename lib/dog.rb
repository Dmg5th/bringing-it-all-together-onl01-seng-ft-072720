class Dog  
  
  attr_accessor :name, :breed 
  attr_reader :id
  
  def initialize(id: nil, name:, breed:) 
    @id = id 
    @name = name 
    @breed = breed 
  end 
  
  def self.create_table
    sql = <<-SQL 
      CREATE TABLE dogs (
      id INTEGER PRIMARY KEY , 
      name TEXT, 
      breed TEXT 
      );  
    SQL
    DB[:conn].execute(sql)
  end 
  
  def self.drop_table
      sql = <<-SQL 
      DROP TABLE dogs;  
    SQL
    DB[:conn].execute(sql) 
  end 
  
  def save
    sql = <<-SQL 
      INSERT INTO dogs(name, breed)
      VALUES (?,?)
    SQL
    DB[:conn].execute(sql, self.name, self.breed)  
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    self 
  end 
  
  def self.create(hash)
    dog_obj = Dog.new(hash)
    dog_obj.save 
    dog_obj 
   
  end 
  
  def self.new_from_db(row)
      id = row[0] 
      name = row[1]
      breed = row[2]
      self.new(id: id, name: name, breed: breed)
      # binding.pry 
  end 
  
  def self.find_by_id(id)
    sql = <<-SQL
    SELECT * FROM dogs
    WHERE id = ?
    SQL
    result = DB[:conn].execute(sql, id)[0][0]
    DB[:conn].execute(sql,id).map do |row|
            self.new_from_db(row)
    end.first
    # binding.pry 
  end 
  
  def self.find_or_create_by(name:, breed:)
    dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND breed = ?", name, breed)
    if !dog.empty?
      dog_data = dog[0]
      dog = Dog.new(id: dog_data[0], name: dog_data[1], breed: dog_data[2])
    else
      dog = self.create(name: name, breed: breed)
    end
    dog 
  end
 
    
  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM dogs 
    WHERE name = ? 
    SQL
    result = DB[:conn].execute(sql, name)[0]
    Dog.new(id: result[0], name: result[1], breed: result[2])
      # binding.pry 
  end 
  
  def update 
    sql = <<-SQL 
    UPDATE dogs SET name = ?, breed = ? WHERE id = ?"
    SQL
    
    DB[:conn].execute(sql, self.name, self.breed, self.id)
   binding.pry 
  end 


  
  
  
  
  
end 