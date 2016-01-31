require "db"
require "../src/sqlite3"

DB.open "sqlite3", ":memory:" do |db|
  db.exec "create table contacts (name string, age integer)"
  db.exec "insert into contacts values (?, ?)", "John Doe", 30
  db.exec "insert into contacts values (:name, :age)", {name: "Sarah", age: 33}

  puts "max age:"
  puts db.scalar "select max(age) from contacts" # => 33

  puts "contacts:"
  db.query "select name, age from contacts order by age desc" do |rs|
    puts "#{rs.column_name(0)} (#{rs.column_name(1)})"
    # => name (age)
    rs.each do
      puts "#{rs.read(String)} (#{rs.read(Int32)})"
      # => Sarah (33)
      # => John Doe (30)
    end
  end
end