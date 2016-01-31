class SQLite3::Connection < DB::Connection
  def initialize(connection_string)
    super
    check LibSQLite3.open_v2(connection_string, out @db, (LibSQLite3::Flag::READWRITE | LibSQLite3::Flag::CREATE), nil)
  end

  def prepare(query)
    Statement2.new(self, query)
  end

  def perform_close
    LibSQLite3.close_v2(self)
  end

  def last_insert_id : Int64
    LibSQLite3.last_insert_rowid(self)
  end

  def to_unsafe
    @db
  end

  private def check(code)
    raise Exception.new(self) unless code == 0
  end
end