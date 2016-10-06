# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative 'treasure_kind.rb'

module NapakalakiGame
  class BadConsequence
    # Son los gets
    attr_reader :text
    attr_reader :levels
    attr_reader :nVisibleTreasures
    attr_reader :nHiddenTreasures
    attr_reader :death  
    attr_reader :specificHiddenTreasures
    attr_reader :specificVisibleTreasures
    @@MAXTREASURES=10
    # Constructor privado de la clase.
    def initialize(aText, someLevels, someVisibleTreasures, someHiddenTreasures,
                   someSpecificVisibleTreasures, someSpecificHiddenTreasures, death)
      @text=aText
      @levels=someLevels
      @nVisibleTreasures=someVisibleTreasures
      @nHiddenTreasures=someHiddenTreasures
      @death=death
      @specificHiddenTreasures= Array.new
      @specificVisibleTreasures= Array.new
      @specificHiddenTreasures=someSpecificHiddenTreasures.clone
      @specificVisibleTreasures=someSpecificVisibleTreasures.clone

    end
    
    # Primer constructor: Inicializa el texto, perdida de nivel,
    # perdida de objetos visibles y ocultos
    def self.newLevelNumberOfTreasures(aText, someLevels, someVisibleTreasures, someHiddenTreasures)
      new(aText,someLevels,someVisibleTreasures,someHiddenTreasures,[],[],false)
    end
    # Segundo constructor: Inicializa el texto, perdida de nivel y dos listas
    # con la perdida de objetos.
    def self.newLevelSpecificTreasures(aText,someLevels, someSpecificVisibleTreasures, 
        someSpecificHiddenTreasures)
      new(aText,someLevels,0,0,someSpecificVisibleTreasures,someSpecificHiddenTreasures,false)
    end
    
    def getLevels
      @levels
    end
    
    # Constructor que inicializa el texto y pone muerto a verdadero.
    def self.newDeath(aText)
      new(aText,0,0,0,[],[],true)
    end
    
    def isEmpty
      badConsequence_vacio = false
      if @nVisibleTreasures==0 and @nHiddenTreasures==0 and @specificVisibleTreasures.length==0 and
          @specificHiddenTreasures.length==0
        badConsequence_vacio=true
      end
      
      badConsequence_vacio
    end
    def to_s
      "\nTexto: #{@text}\nNiveles perdidos: #{@levels}
      Armas visibles perdidas: #{@nVisibleTreasures}\n Armas ocultas perdidas #{@nHiddenTreasures}
      Muerto: #{@death}"
    end
    
    def substractVisibleTreasures(treasure)
      if(@specificVisibleTreasures.include?(treasure.getType))
          @specificVisibleTreasures.delete(treasure.getType)
      elsif @nVisibleTreasures != 0
          @nVisibleTreasures = @nVisibleTreasures - 1         
      end
    end
    
    def substractHiddenTreasures(treasure)
      if(@specificHiddenTreasures.include?(treasure.getType))
          @specificHiddenTreasures.delete(treasure.getType)
      elsif @nHiddenTreasures != 0
          @nHiddenTreasures = @HiddenTReasures - 1         
      end
    end
    
    def CuantasOneHand(elVector)
      num_onehand=0
      for i in 0..elVector.length
         if elVector.at(i).equal?(TreasureKind::ONEHAND)
           num_onehand = num_onahand + 1
         end
      end
    end
    
    
    def adjustToFitTreasureList(visible, hidden)
      nOcultos=0
      nVisibles=0
      specificH = Array.new
      specificV = Array.new 
      if @nHiddenTreasures!=0 or @nVisibleTreasures!=0
        if @nHiddenTreasures!=0
          if @nHiddenTreasures > hidden.length
            nOcultos=hidden.length
          else
            nOcultos=@nHiddenTreasures
          end
        end
        
        if @nVisibleTreasures!=0
          if @nVisibleTreasures > visible.length
            nVisible=visible.length
          else
            nVisible=@nVisibleTreaures
          end
        end
        
        badConsequence = BadConsequence.newLevelNumberOfTreasures(@text, @levels, nVisible, nOcultos)
        
        else
          if visible.nil?
          num_onehand=CuantasOneHand(visible)
          i=0
          while i < visible.length
            treasureKind=visible[i].type
            continuar = true
            j=0
            while j < @specificVisibleTreasuser.length and continuar
              if treasureKind.equal?(@specificVisibleTreasures[j])
                if treasureKind.equal?(TreasureKind::ONEHAND)
                  if(num_onehand != 0)
                    num_onehand = num_onehand - 1
                    objeto = visible[i].getType
                    specificV.push(objeto)
                    if num_onehand == 0
                      continuar=false
                    end
                  end
                else
                  objeto = visible[i].getType
                  specificV.push(objeto)
                  continuar = false
                end
              end
              j=j+1
            end
            i=i+1
          end
          end
          if hidden.nil?
          num_onehand=CuantasOneHand(hidden)

          i=0
          while(i < @specificHiddenTreasures.length)
            treasureKind = @specificHiddenTreasures[i]

            continuar=true

            j=0
            while j < hidden.length and continuar
              if treasureKind.equal?(hidden[j].getType)
                if treasureKind.equal?(TreasureKind::ONEHAND)
                 if num_onehand != 0
                    num_onehand = num_onahand -1
                    objeto=@specificHiddenTreasures[i].getType
                    specificH.push(objeto)
                    if num_onehand == 0
                      continuar=false
                    end
                 end
                else
                  objeto = @specificHiddenTreasures[i].getType
                  specificH.push(objeto)
                  continuar=false
                end
              end
              j=j+1
            end
            i=i+1
          end
          end
          
        badConsequence = BadConsequence.newLevelSpecificTreasures(@text, @levels, specificV, specificH)
      end 
      
      badConsequence
    end
    
    
    

    # Devuelve si el array de objetos visibles esta vacio
    def getNingunObjetoVisibleEspecifico
      ningun_objeto=false
      # Comprueba que el array este vacio. Eso quiere decir que la carta de mal rollo
      # no obliga al usuario a perder un objeto especifico
      if @specificVisibleTreasures.length == 0
        ningun_objeto=true

      end
      
      ningun_objeto
    end
    # Devuelve si el array de objetos ocultos esta vacio
    def getNingunObjetoOcultoEspecifico
      
      ningun_objeto=false
      # Lo mismo que el anterior metodo. Si el array esta vacio quiere decir que el usuario
      # no pierde ningun objeto en concreto
      if @specificHiddenTreasures.length ==0
        ningun_objeto=true
      end
      
      ningun_objeto
    end
    
    # Comprueba que el objeto lo tiene el mal rollo.
    def getObjetoPierdeLoTiene(objeto)
      existe=false
      
      if @specificHiddenTreasures.include?(objeto) or @specificVisibleTreasures.include?(objeto)
        existe=true
      end
      
      existe
    end
    
    # new es privado para poder tener varios constructores.
    private_class_method :new

  end
end