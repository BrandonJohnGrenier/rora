#
# A player in a Texas Hold'em game.
#
class Player
  attr_reader :name, :funds

  def initialize name=nil, funds=nil
    @name = name
    @funds = funds.nil? ? 0 : funds
    @sessions = Hash.new
  end

  def with_name name
    @name = name
    self
  end

  def with_funds funds
    @funds = funds
    self
  end

  def join table, seat=nil
    raise ArgumentError, "This table is full" if table.full?
    raise ArgumentError, "#{@name} is already sitting at this table" if @sessions.has_key? table
    table.add self, seat
    @sessions[table] = Session.new self, table
  end

  def leave table
    if @sessions.has_key? table
      finish_session table
      @sessions.remove table
    end
    table.remove self
  end

  def start_session table, stack
    raise ArgumentError, "#{@name} is not sitting at this table" if !@sessions.has_key? table
    raise ArgumentError, "#{@name} cannot start with a $#{stack} stack, as it exceeds available funds: $#{funds}" if stack > @funds
    @sessions[table].start stack
    @funds = @funds - stack
  end

  def finish_session table
    if @sessions.has_key? table
      @sessions[table].finish
    end
  end

end
