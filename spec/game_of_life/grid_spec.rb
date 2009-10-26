require File.join( File.dirname(__FILE__), '..', 'spec_helper' )

describe GameOfLife::Grid do
  
  def default_grid
    [ [ 0, 0, 0 ],
      [ 1, 0, 0 ],
      [ 1, 1, 0 ],
      [ 1, 1, 1 ] ]
  end
  
  describe "working with the grid's cells" do
    
    before :each do
      @grid = GameOfLife::Grid.new default_grid      
    end
   
    it "should determine if a cell is alive" do
      @grid.get_cell(0,0).alive.should == false
      @grid.get_cell(1,0).alive.should == true
    end

    it "should assume a status of dead if requested cell does not exist" do
      
      @grid.get_cell(-1,0).alive.should == false
      @grid.get_cell(-1,  -1).alive.should == false
      @grid.get_cell(0,  -1).alive.should == false
      @grid.get_cell(0, 100).alive.should == false
      @grid.get_cell(100,  -1).alive.should == false
      @grid.get_cell(100,   0).alive.should == false
      @grid.get_cell(100, 100).alive.should == false
      
    end
    
    it "should get a cell's live neighbor count" do
      @grid.neighbor_count(@grid.get_cell(0,0)).should == 1
      @grid.neighbor_count(@grid.get_cell(1, 1)).should == 3
      @grid.neighbor_count(@grid.get_cell(2, 1)).should == 5
    end
    
  end
end