class DataBaseException < StandardError

  def initialize(exception)
    puts exception.message
    puts exception.backtrace.inspect
  end
end