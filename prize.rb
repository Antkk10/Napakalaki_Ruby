# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.


module NapakalakiGame
  class Prize
    attr_reader :treasure
    attr_reader :level

    def initialize(treasure, level)
      @treasure=treasure
      @level=level    
    end
    
    def to_s
      "\nTesoros ganados: #{@treasure}\n Niveles ganados: #{@level}\n"
    end
  end
end
