# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require_relative 'monster.rb'
require_relative 'bad_consequence.rb'
require_relative 'combat_result.rb'
require_relative 'card_dealer.rb'
require_relative 'player.rb'

module NapakalakiGame
  class Napakalaki
    include Singleton

    def initialize
      @currentPlayer
      @dealer = CardDealer.instance
      @players = Array.new
      @currentMonster
    end
    def developCombat
      combatResult = @currentPlayer.combat(@currentMonster)
      
      @dealer.giveMonsterBack(@currentMonster)
      
      combatResult
    end
    def getCurrentPlayer
      @currentPlayer
    end
    def getCurrentMonster
      @currentMonster
    end
    def discardVisibleTreasures(treasures)
      i=0
      
      while(i<treasures.length)
        treasure=treasures[i]
        @currentPlayer.discardVisibleTreasure(treasure)
        @dealer.giveTreasureBack(treasure)
        i=i+1
      end
    end
    
    def discardHiddenTreasures(treasures)
      i=0
      
      while(i<treasures.length)
        treasure=treasures[i]
        @currentPlayer.discardHiddenTreasure(treasure)
        @dealer.giveTreasureBack(treasure)
        i=i+1
      end
    end
    
    def makeTreasuresVisible(treasures)
      i = 0
      while(i < treasures.length)
        @currentPlayer.makeTreasureVisible(treasures[i])
        i=i+1
      end
    end
    private
    def initPlayers(names)
      i = 0
      @players = Array.new 
      while(i<names.length)
        jugador = Player.new(names[i])
        @players.push(jugador)
        i=i+1
      end
    end
    
    def nextPlayer
      
      jugador=0
      if @currentPlayer.nil?
        numero = rand(@players.length)
        jugador = @players[numero]
      else
        jug_siguiente = @players.index(@currentPlayer)
        total_jugadores = @players.length
        jug_siguiente = (jug_siguiente + 1) % total_jugadores
        jugador = @players[jug_siguiente]
      end
      
      jugador
    end
    
    def setEnemies
      
      total_jugadores = @players.length
      i=0
      
      while(i<total_jugadores)
        aleatorio = rand(total_jugadores)
        
        if i != aleatorio
          @players[i].setEnemy(@players[aleatorio])
          i=i+1
        end
      end
    end
    
    public
    def nextTurn
      stateOK = nextTurnAllowed
      
      if stateOK
        @currentMonster=@dealer.nextMonster
        @currentPlayer = nextPlayer
        
        if @currentPlayer.getDead
          @currentPlayer.initTreasures
        end
      end
      
      stateOK
    end
    
    def initGame(players)
      
      initPlayers(players)
      
      setEnemies
      
      
      @dealer.initCards
      
      nextTurn
    end
    
    def endOfGame(result)
      final=false
      if result.equal?(CombatResult::WINGAME)
        final=true
      end
      
      final
    end
    
    private

    
    
    def nextTurnAllowed
      siguiente=true
      if @currentPlayer.nil?
        siguiente=true
      else
        siguiente = @currentPlayer.validState
      end
      
      siguiente
    end
    

    
  end
end
