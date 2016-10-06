# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require 'singleton'
require_relative 'treasure.rb'
require_relative 'monster.rb'
module NapakalakiGame
  class CardDealer
    include Singleton

    def nextTreasure
      # Por defecto
      treasure = nil
      if @unusedTreasures.empty?
        @unusedTreasures = @usedTreasures
        @usedTreasures = Array.new 
        shuffleTreasures
        treasure = @unusedTreasures[0]
        @unusedTreasures.delete_at(0)
      else
        shuffleTreasures
        treasure = @unusedTreasures[0]
        @usedTreasures.push(@unusedTreasures[0])
        @unusedTreasures.delete_at(0)
      end
      
      treasure
    end
    
    def nextMonster
      monstruo=0
      if @unusedMonster.empty? 
        
        @unusedMonster=@usedMonster
        @usedMonster = Array.new
        shuffleMonsters
        monstruo = @unusedMonster[0]
        @usedMonster.push(monstruo)
        @unusedMonster.delete(0)

      else
        shuffleMonsters
        monstruo = @unusedMonster[0]
        @usedMonster.push(monstruo)
        @unusedMonster.delete(0)
      end
      
      monstruo
    end
    
    def giveTreasureBack(t)
      @usedTreasures.push(t)
    end
    
    def giveMonsterBack(monster)
      @usedMonster.push(monster)
    end
    

    
    def shuffleTreasures
      @unusedTreasures.shuffle!
    end
    def shuffleMonsters
      @unusedMonster.shuffle!
    end
    
    private
    def initTreasureCardDeck
      @unusedTreasures = Array.new
      @usedTreasures = Array.new
      @unusedTreasures.push(Treasure.new("Si mi amo!",4,TreasureKind::HELMET))
      @unusedTreasures.push(Treasure.new("Botas de investigacion",3,TreasureKind::SHOES))
      @unusedTreasures.push(Treasure.new("Capucha de Cthulhu",3,TreasureKind::HELMET))
      @unusedTreasures.push(Treasure.new("A prueba de babas",2,TreasureKind::ARMOR))
      @unusedTreasures.push(Treasure.new("Botas de lluviaacida",1,TreasureKind::BOTHHANDS))
      @unusedTreasures.push(Treasure.new("Casco minero",2,TreasureKind::HELMET))
      @unusedTreasures.push(Treasure.new("Ametralladora Thompson",4,TreasureKind::BOTHHANDS))
      @unusedTreasures.push(Treasure.new("Camiseta de la UGR",1,TreasureKind::ARMOR))
      @unusedTreasures.push(Treasure.new("Clavo de rail ferroviario",3,TreasureKind::ONEHAND))
      @unusedTreasures.push(Treasure.new("Cuchillo de sushi arcano",2,TreasureKind::ONEHAND))
      @unusedTreasures.push(Treasure.new("Fez alopodo",3,TreasureKind::HELMET))
      @unusedTreasures.push(Treasure.new("Hacha prehistorica",2,TreasureKind::ONEHAND))
      @unusedTreasures.push(Treasure.new("El aparato del Pr. Tesla",4,TreasureKind::ARMOR))
      @unusedTreasures.push(Treasure.new("Gaita",4,TreasureKind::BOTHHANDS))
      @unusedTreasures.push(Treasure.new("Insecticida",2,TreasureKind::ONEHAND))
      @unusedTreasures.push(Treasure.new("Escopeta de 3 canones",4,TreasureKind::BOTHHANDS))
      @unusedTreasures.push(Treasure.new("Garabato mistico",2,TreasureKind::ONEHAND))
      @unusedTreasures.push(Treasure.new("La rebeca metalica",2,TreasureKind::ARMOR))
      @unusedTreasures.push(Treasure.new("Lanzallamas",4,TreasureKind::BOTHHANDS))
      @unusedTreasures.push(Treasure.new("Necro-comicon",1,TreasureKind::ONEHAND))
      @unusedTreasures.push(Treasure.new("Necronomicon",5,TreasureKind::BOTHHANDS))
      @unusedTreasures.push(Treasure.new("Linterna a 2 manos",3,TreasureKind::BOTHHANDS))
      @unusedTreasures.push(Treasure.new("Necro-gnomicon",2,TreasureKind::ONEHAND))
      @unusedTreasures.push(Treasure.new("Necrotelecom",2,TreasureKind::HELMET))
      @unusedTreasures.push(Treasure.new("Mazo de los antiguos",3,TreasureKind::ONEHAND))
      @unusedTreasures.push(Treasure.new("Necroplayboycon",3,TreasureKind::ONEHAND))
      @unusedTreasures.push(Treasure.new("Porra preternatural",2,TreasureKind::ONEHAND))
      @unusedTreasures.push(Treasure.new("Shogulador",1,TreasureKind::BOTHHANDS))
      @unusedTreasures.push(Treasure.new("Varita de atizamiento",3,TreasureKind::ONEHAND))
      @unusedTreasures.push(Treasure.new("Tentaculo de pega",2,TreasureKind::HELMET))
      @unusedTreasures.push(Treasure.new("Zapato deja-amigos",1,TreasureKind::SHOES))   
    end
    
    def initMonsterCardDeck
      @unusedMonster = Array.new
      @usedMonster = Array.new
  
      badConsequence = BadConsequence.newLevelSpecificTreasures("Pierdes tu armadura visible y otra oculta.",
        0,[TreasureKind::ARMOR], [TreasureKind::ARMOR])
      prize = Prize.new(2,1)
      @unusedMonster << Monster.new("3 Byakhees de bonanza",8,badConsequence,prize)

      badConsequence = BadConsequence.newLevelSpecificTreasures("Embobados con el lindo primigenio te descartas de tu casco visible",
        0,[TreasureKind::HELMET],[])
      prize = Prize.new(1,1)
      @unusedMonster << Monster.new("Chibithulhu",2,badConsequence,prize)

      badConsequence = BadConsequence.newLevelSpecificTreasures("El primordial bostezo contagioso. Pierdes el calzado visible.",
      0,[TreasureKind::SHOES],[])
      prize = Prize.new(1,1)
      @unusedMonster << Monster.new("El sopor de Dunwich",2,badConsequence,prize)

      badConsequence = BadConsequence.newLevelSpecificTreasures("Te atrapan para llevarte de fiesta y te dejan caer en mitad del vuelo. Descarta 1 mano visible y 1 mano oculta.",
        0,[TreasureKind::ONEHAND],[TreasureKind::ONEHAND])
      prize = Prize.new(4,1)
      @unusedMonster << Monster.new("Angeles de la noche ibicenca",14,badConsequence,prize)

      badConsequence = BadConsequence.newLevelNumberOfTreasures("Pierdes todos tus tesoros visibles.",
        0,10,0)
      prize = Prize.new(3,1)
      @unusedMonster << Monster.new("El gorron en el umbral",10,badConsequence,prize)

      badConsequence = BadConsequence.newLevelSpecificTreasures("Pierdes la armadura visible.",
        0,[TreasureKind::ARMOR],[])
      prize = Prize.new(2,1)
      @unusedMonster << Monster.new("H.P. Munchcraft",6,badConsequence,prize)

      badConsequence = BadConsequence.newLevelSpecificTreasures("Sientes bichos bajo la ropa. Descarta la armadura visible.",
        0,[TreasureKind::ARMOR],[])
      prize = Prize.new(1,1)
      @unusedMonster << Monster.new("Bichgooth",2,badConsequence,prize)

      badConsequence = BadConsequence.newLevelNumberOfTreasures("Pierdes 5 niveles y 3 tesoros visibles",
        5,3,0)
      prize = Prize.new(4,2)
      @unusedMonster << Monster.new("El rey de rosa",13,badConsequence,prize)

      badConsequence = BadConsequence.newLevelNumberOfTreasures("Toses los pulmones y pierdes 2 niveles.",
        2,0,0)
      prize = Prize.new(1,1)
      @unusedMonster << Monster.new("La que redacta en las tinieblas.",2,badConsequence,prize)

      badConsequence = BadConsequence.newDeath("Estos monstruos resultan bastante superficiales y te aburren mortalmente. Estas muerto,")
      prize = Prize.new(2,1)
      @unusedMonster << Monster.new("Los hondos",8,badConsequence, prize)

      badConsequence = BadConsequence.newLevelNumberOfTreasures("Pierdes 2 niveles y 2 tesoros ocultos",
        2,0,2)
      prize = Prize.new(2,1)
      @unusedMonster << Monster.new("Semillas Cthulhu",4,badConsequence, prize)

      badConsequence = BadConsequence.newLevelSpecificTreasures("Te intentas escaquear. Pierdes una mano visible",
        0,[TreasureKind::ONEHAND],[])
      prize = Prize.new(2,1)
      @unusedMonster << Monster.new("Dameargo",1,badConsequence,prize)

      badConsequence = BadConsequence.newLevelNumberOfTreasures("Da mucho asquito. Pierdes 3 niveles",
        3,0,0)
      prize = Prize.new(1,1)
      @unusedMonster << Monster.new("Pollipolipo volante", 3,badConsequence,prize)

      badConsequence = BadConsequence.newDeath("No le hace gracia que pronuncien mal su nombre. Estas muerto")
      prize = Prize.new(3,1)
      @unusedMonster << Monster.new("Yskhtihyssg-Goth",12,badConsequence,prize)

      badConsequence=BadConsequence.newDeath("La familia te atrapa. Estas muerto.")
      prize = Prize.new(4,1)
      @unusedMonster << Monster.new("Familia feliz",1,badConsequence,prize)

      badConsequence=BadConsequence.newLevelSpecificTreasures("La quinta directira primaria te obliga a perder 2 niveles y un tesoro 2 manos visibles",
      2,[TreasureKind::BOTHHANDS],[])
      prize = Prize.new(2,1)
      @unusedMonster << Monster.new("Roboggoth",8,badConsequence,prize)

      badConsequence = BadConsequence.newLevelSpecificTreasures("Te asusta en la noche. Pierdes un casco visible.",
        0,[TreasureKind::HELMET],[])
      prize = Prize.new(1,1)
      @unusedMonster << Monster.new("El espia",5,badConsequence,prize)

      badConsequence = BadConsequence.newLevelNumberOfTreasures("Menudo susto te llevas. Pierdes 2 niveles y 5 tesoros visibles",
        2,5,0)
      prize = Prize.new(1,1)
      @unusedMonster << Monster.new("El lenguas",20,badConsequence,prize)

      badConsequence = BadConsequence.newLevelSpecificTreasures("Te faltan manos para tanta cabeza. Pierdes 3 niveles y tus tesoros visibles de las manos",
        3,[TreasureKind::BOTHHANDS,TreasureKind::ONEHAND,TreasureKind::ONEHAND],
        [TreasureKind::BOTHHANDS,TreasureKind::ONEHAND,TreasureKind::ONEHAND])
      prize = Prize.new(1,1)
      @unusedMonster << Monster.new("Bicefalo",20,badConsequence,prize)
    end
    
    public
    
    def initCards
      initMonsterCardDeck
      initTreasureCardDeck
      shuffleMonsters
      shuffleTreasures
    end
    
    
  end
end
