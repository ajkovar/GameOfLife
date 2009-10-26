module GameOfLife
  
  # Determines flow of game and applies rules
  class Game
    
    def initialize grid_seed
      @grid = Grid.new grid_seed
    end
    
    def grid
       @grid.grid
    end
    
    def new_generation
      @grid.pad_grid
      new_grid = Grid.new []

      @grid.each do |cell|
        cell.status = new_status_of cell
        new_grid.set_cell cell
      end

      @grid = new_grid
    end
    
    def new_status_of cell
      count  = @grid.neighbor_count cell
      ( count == 3 or ( count == 2 and cell.alive ) ) ? 1 : 0
    end
    
    def output options={}
      @grid.to_s options
    end
    
  end
  
  class Cell
    
    attr_reader :col, :row
    attr_accessor :status
    
    def initialize row, col, status
      @row = row
      @status = status
      @col = col
    end
    
    def alive
     @status == 1
    end
   
  end
  
  # Handles cell transversal and basic grid operations
  class Grid
    
    attr_reader :grid
    
    def initialize grid
      @grid = grid
    end
    
    def set_cell cell
      if(!@grid[cell.row])
        @grid[cell.row] = []
      end
      @grid[cell.row][cell.col]=cell.status
    end
    
    def get_cell row, col
      Cell.new row, col, status_of(row, col)
    end
    
    def neighbor_count cell, radius=1
      count=0;
      (-radius..radius).each do |row_offset| 
        (-radius..radius).each do |col_offset|
          
          #offset [0, 0] is the cell being counted
          count+= (row_offset==0 and col_offset==0) ? 0 : status_of(cell.row + row_offset, cell.col + col_offset)
        end
      end
      count
    end

    def pad_grid
      pad_grid_bottom
      pad_grid_left
      pad_grid_right
      pad_grid_top
    end
    
    def to_s options = {}
      str = @grid.map { |row| row.join }.join("\n")
      str.gsub! '1', options[:live] if options[:live]
      str.gsub! '0', options[:dead] if options[:dead]
      str
    end
    
    def each
      @grid.each_with_index do |cols, row_id|
        cols.each_with_index do |col, col_id|
          yield Cell.new(row_id, col_id, @grid[row_id][col_id])
        end
      end
    end
    
    private
    
    def status_of row, col
      return 0 if row < 0 or col < 0
      @grid[row][col] || 0 rescue 0
    end
    
    def pad_grid_bottom
      bottom = @grid.last.join
      @grid << Array.new(@grid.last.length).fill(0) if bottom =~ /111/
    end  
    
    def pad_grid_left
      left = @grid.inject('') { |str, grid| str += grid.first.to_s } 
      @grid.each { |row| row.unshift 0 } if left =~ /111/
    end
    
    def pad_grid_right
      right = @grid.inject('') { |str, grid| str += grid.last.to_s } 
      @grid.each { |row| row << 0 } if right =~ /111/
    end
    
    def pad_grid_top
      top = @grid.first.join
      @grid.unshift Array.new(@grid.first.length).fill(0) if top =~ /111/
    end
    
  end

end