# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require_relative 'dice.rb'
require_relative 'treasure.rb'
require_relative 'card_dealer.rb'
require_relative 'combat_result.rb'
require_relative 'bad_consequence.rb'

module NapakalakiGame
  attr_reader :name
  attr_reader :level
  attr_reader :dead
  attr_reader :canISteal
  
  @@MAXLEVEL=10
  
  class Player
    def initialize(name)
      @name=name
      @level=1  
      @dead=true
      @canISteal=true
      @hiddenTreasures=Array.new
      @visibleTreasures=Array.new
      @enemy=nil;
      @pendingBadConsequence=nil;
    end
    
    def getCanISteal
      @canISteal
    end
    
    def canYouGiveMeATreasure
      poder_robar=true
      if @hiddenTreasures.empty?
        poder_robar=false
      end
      
      poder_robar
    end
    
    def to_s
      "Nombre #{@name}, nivel #{@level}"
    end
    
    def getName
      @name
    end
    
    def getDead
      @dead
    end
    def getHiddenTreasures
      @hiddenTreasures
    end
    
    def getVisibleTreasures
      @visibleTreasures
    end
    
    # Metodo que simula el combate entre monster y player
    # Devuelve el resultado del combate
    def combat(monster)
      # contiene el nivel del jugador
      myLevel = getCombatLevel
      # contiene el nivel del monstruo
      monsterLevel = monster.getcombatLevel
     
      
      #Comprobamos si gana el jugador al monstruo
      if myLevel > monsterLevel
        applyPrize(monster)
        if @level >= 10
          #Ha ganado el juego
          combatResult = CombatResult::WINGAME
        else
          # Solo ha ganado el combate
          combatResult = CombatResult::WIN
        end
      else
        applyBadConsequence(monster)
        combatResult = CombatResult::LOSE
      end
      
      combatResult
    end
    
    #Metodo que cambia el tesoro de oculto a visible
    def makeTreasureVisible(treasure)
      if ( canMakeTreasureVisible(treasure) )
        @visibleTreasures.push(treasure)
        @hiddenTreasures.delete(treasure)
      end
    end
    # Metodo que descarta un tesoro visible
    def discardVisibleTreasure(treasure)
      # Comprueba si el array contien el tesoro
      #if @visibleTreasures.include?(treasure)
        # elimina el tesoro visible
        @visibleTreasures.delete(treasure)
      #end
      #Comprueba si queda mala consecuencia por cumplir
      if ((@pendingBadConsequence!= nil) and @pendingBadConsequence.isEmpty)
         # Actualiza la mala consecuencia pendiente para que el tesoro
         # no forme parte de la mala consecuencia
         @pendingBadConsequence.subtractVisibleTreasure(treasure)
         
      end
      
      dielfNoTreasures 
    end
    
    def isDead
      if @dead
        discardAllTreasures
      end
      
      @dead
    end
    # Metodo que descarta un tesoro oculto
    def discardHiddenTreasure(treasure)
      # Comprueba si el tesoro esta dentro de los tesoros ocultos
      #if @hiddenTreasures.include?(treasure)
        # Borra el tesoro de los tesoros ocultos
        @hiddenTreasures.delete(treasure)
      #end
      #Comprueba si queda una mala consecuencia por cumplir
      if ((@pendingBadConsequence!= nil) and @pendingBadConsequence.isEmpty)
        # Actualiza la mala consecuencia pendiente para que el tesoro
        # no forme parte de la mala consecuencia
        @pendingBadConsequence.subtractVisibleTreasure(treasure)
      end
      
      dielfNoTreasures      
    end
    
    def validState
      #estado_valido = @pendingBadConsequence.isEmpty
      #if @visibleTreasures.length <= 4 and estado_valido
      #  estado_valido=true
      #else
       # estado_valido=false
      #end
      
      estado_valido = false
      
      if @pendingBadConsequence.nil?
        estado_valido=true
      else
        if ((@pendingBadConsequence.isEmpty) and (@hiddenTreasures.length <= 4))
          estado_valido=true
        end
      end
      
      estado_valido
    end
    
    def initTreasures
      @dealer = CardDealer.instance
      @dice = Dice.instance
      bringToLife
      treasure = @dealer.nextTreasure
      @hiddenTreasures.push(treasure)
      number = @dice.nextNumber
      if number > 1
        treasure = @dealer.nextTreasure
        @hiddenTreasures.push(treasure)
      end
      if number == 6
        treasure = @dealer.nextTreasure
        @hiddenTreasures.push(treasure)
      end
    end
    
    def stealTreasure
      treasure = nil
      
      if @canISteal
        puede_robar=@enemy.canYouGiveMeATreasure
        if puede_robar
          treasure = @enemy.giveMeATreasure
          @hiddenTreasures.push(treasure)
          haveStolen
        end
      end
      
      treasure
    end
    
    def setEnemy(enemy)
      @enemy=enemy
    end
    
    
    def discardAllTreasures
      
      while(@visibleTreasures.length != 0)
        treasure = @visibleTreasures[0]
        discardVisibleTreasure(treasure)
      end
      
      while(@hiddenTreasures.length != 0)
        treasure = @hiddenTreasures[0]
        discardHiddenTreasure(treasure)
      end
    end

    private
      
    def bringToLife
      @death=false
    end
    
    def getCombatLevel
      suma=0
      i=0
      
      while(i<@visibleTreasures.length)
        suma=suma+@visibleTreasures[i].bonus
        i=i+1
      end
      
      suma=suma+@level
      
      suma
    end
    
    def incrementLevels(l)
      if((@level+l)>10)
        @level=10
      else
        @level=@level+l
      end
    end
    
    def decrementLevels(l)
      if(@level-l)<=0
        @level=1
      else
        @level=@level-l
      end
    end
    
    def setPendingBadConsequence(b)
      @pendingBadConsequence=b
    end
    
    # Metodo que aplica premio al jugador
    def applyPrize(m)
      nlevels=m.getLevelsGained
      incrementLevels(nlevels)
      ntreasures =m.getTreasuresGained
      
      if ntreasures > 0
        dealer = CardDealer.instance
        i=1
        
        while i<=ntreasures
          treasure = dealer.nextTreasure
          @hiddenTreasures.push(treasure)
          i=i+1
        end 
        
      end
      
    end
    
    # Metodo que aplica mala consecuencia al jugador
    def applyBadConsequence(m)
      badConsequence = m.getBadConsequence
      nlevels = badConsequence.getLevels
      decrementLevels(nlevels)
      if badConsequence.death
        discardAllTreasures
      else
        pendingBad = badConsequence.adjustToFitTreasureList(@visibleTreasures, @hiddenTreasures)
        setPendingBadConsequence(pendingBad)
      end
      
    end
    
    # Metodo que comprueba si un tesoro se puede hacer visible
    def canMakeTreasureVisible(t)
      canMakeTreasureVisible = false
      if ( t.getType.equal?(TreasureKind::ONEHAND ))
        canMakeTreasureVisible = (howManyVisibleTreasures(TreasureKind::ONEHAND) <= 1) && (howManyVisibleTreasures(TreasureKind::BOTHHANDS) == 0)
      elsif ( t.getType.equal?(TreasureKind::BOTHHANDS ))
        canMakeTreasureVisible = howManyVisibleTreasures(TreasureKind::ONEHAND) == 0
      elsif ( howManyVisibleTreasures(t.getType) == 0 )
        canMakeTreasureVisible = true
      end
      canMakeTreasureVisible       
    end
    
    # Metodo que cuenta cuantos objetos del mismo tipo tiene visibles.
    def howManyVisibleTreasures(tkind)
      contador_obj = 0
      
      i=0
      while(i < @visibleTreasures.length)
        if @visibleTreasures[i].getType.equal?(tkind)
          contador_obj=contador_obj+1
        end
        i=i+1
      end
      
      contador_obj
    end
    
    # Cambia el estado de jugador a muerto cuando el jugador pierde todos sus tesoros.
    def dielfNoTreasures
        
      if @hiddenTreasures.empty? and @visibleTreasures.empty?
        @death=true
      end
    end
    
    def giveMeATreasure
      numero = rand(@hiddenTreasures.length)
      
      treasure = @hiddenTreasures[numero]
      
      # Ojo
      @hiddenTreasures.delete_at(numero)
      
      treasure
    end
    
    
    def haveStolen
      @canISteal=false
    end
    
  end
end
