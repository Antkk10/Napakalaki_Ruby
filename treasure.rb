# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require_relative 'treasure_kind.rb'

module NapakalakiGame
  class Treasure
    attr_reader :name
    attr_reader :bonus
    attr_reader :type
    def initialize(name, bonus, treasure)
      @name=name
      @bonus=bonus
      @type=treasure      
    end
    
    def getType
      @type
    end
    
    def to_s
      "\nNombre: #{@name}, Bonus: #{@bonus}\n"
    end
   
  end
end
