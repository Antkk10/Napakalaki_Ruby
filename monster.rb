# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require_relative 'bad_consequence.rb'
require_relative 'prize.rb'

module NapakalakiGame
  class Monster
    attr_reader :name
    attr_reader :combatLevel
    

    def initialize(name, level, bc, prize)
      @name=name
      @combatLevel=level
      @bc=bc.clone
      @prize=prize.clone    
    end
    def getName
      @name
    end
    def getBadConsequence
      @bc
    end
    
    def getLevelsGained
      @prize.level
    end
    
    def getcombatLevel
      @combatLevel
    end
    
    def getTreasuresGained
      @prize.treasure
    end
    
    def to_s
      "Nombre del monstruo: #{@name}\nNivel de combate: #{@combatLevel}\nMal rollo: #{@bc.to_s}\nPremio: #{@prize.to_s}"
    end
    
    
  end
end
