class Player
  def initialize(path, symbol)
    @path = path
    @symbol = symbol # TODO: how do we get this again? parent folder name?
  end
  
  def move(board, reporter)
    square = `./#{@path} #{board.state}`.to_i
    reporter.move(@symbol, square)
    board.update(square, @symbol)
    reporter.state(board.state)
  end
end