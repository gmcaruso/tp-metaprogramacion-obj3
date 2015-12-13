#!/usr/bin/env ruby
# encoding: utf-8
require 'rspec'
require_relative '../lib/prototyped'
require_relative '../lib/prototyped_object'

describe 'Prototypes' do

  let :objeto do
    objeto = PrototypedObject.new
  end

  let :padre do
    padre = PrototypedObject.new
  end
  
  let :hijo do
    hijo = PrototypedObject.new
  end
  
  let :guerrero do
    guerrero = PrototypedObject.new
  end
  
  let :espadachin do
    espadachin = PrototypedObject.new
  end

  it 'Definir nueva propiedad' do
    objeto.set_property(:nueva_propiedad, 100)
    expect(objeto.nueva_propiedad).to eq(100)
    expect(objeto.nueva_propiedad = 200).to eq(200)
  end
  
  it 'Definir nuevo metodo' do
    objeto.set_method(:nombre_metodo, proc {2})
    expect(objeto.nombre_metodo).to eq(2)
  end
  
  it 'Si no se le asigno metodo tira excepcion' do
    expect{objeto.nombre_metodo}.to raise_error NoMethodError
  end
    
  it 'Tiene las propiedades de su prototipo' do
    hijo.set_prototype(padre)

    padre.set_property(:propiedad, 100)
    hijo.propiedad = 20
    expect(hijo.propiedad).to eq(20)
  end

  it 'Tiene los metodos de su prototipo' do
    hijo.set_prototype(padre)
    padre.set_method(:metodo, proc{ 100 })
    expect(hijo.metodo).to eq 100
  end

  it 'No tiene las propiedades de sus hijos' do
    hijo.set_prototype(padre)
    hijo.set_property(:propiedad, proc{ 100 })
    expect{padre.propiedad}.to raise_error NoMethodError
  end

  it 'No tiene los metodos de sus hijos' do
    hijo.set_prototype(padre)
    hijo.set_method(:metodo, proc{ 100 })
    expect{padre.metodo}.to raise_error NoMethodError
  end

  it 'No tiene el estado de su padre' do
    hijo.set_prototype(padre)
    padre.set_property(:propiedad, 100)
    hijo.propiedad = 20
    expect(padre.propiedad).to eq(100)
    expect(hijo.propiedad).to eq(20)
  end
  
  it 'Resolviendo parte 1 del enunciado' do
    guerrero.set_property(:energia, 100)
    expect(guerrero.energia).to eq(100)

    guerrero.set_property(:potencial_defensivo, 10)
    guerrero.set_property(:potencial_ofensivo, 30)
    guerrero.set_method(:atacar_a, proc { |otro_guerrero|
      if(otro_guerrero.potencial_defensivo < self.potencial_ofensivo)
        otro_guerrero.recibe_danio(self.potencial_ofensivo - otro_guerrero.potencial_defensivo)
      end
    })
    guerrero.set_method(:recibe_danio, proc { |danio|
      self.energia = self.energia - danio
    })

    otro_guerrero = guerrero.clone
    guerrero.atacar_a otro_guerrero

    expect(otro_guerrero.energia).to eq(80)
    
    espadachin.set_prototype(guerrero)
    espadachin.set_property(:habilidad, 0.5)
    espadachin.set_property(:potencial_espada, 30)
    espadachin.energia = 100
    
    espadachin.potencial_ofensivo = 0
    
    espadachin.set_method(:potencial_ofensivo, proc {
      @potencial_ofensivo + self.potencial_espada * self.habilidad
    })
    espadachin.atacar_a(otro_guerrero)
    expect(otro_guerrero.energia).to eq(75)
  end

  it 'Resolviendo parte 1 del enunciado mas parte 2' do
    #PARTE 1
    guerrero.set_property(:energia, 100)
    expect(guerrero.energia).to eq(100)

    guerrero.set_property(:potencial_defensivo, 10)
    guerrero.set_property(:potencial_ofensivo, 30)
    guerrero.set_method(:atacar_a, proc { |otro_guerrero|
      if(otro_guerrero.potencial_defensivo < self.potencial_ofensivo)
        otro_guerrero.recibe_danio(self.potencial_ofensivo - otro_guerrero.potencial_defensivo)
      end
    })
    guerrero.set_method(:recibe_danio, proc { |danio|
      self.energia = self.energia - danio
    })

    otro_guerrero = guerrero.clone
    guerrero.atacar_a otro_guerrero

    expect(otro_guerrero.energia).to eq(80)
    

    # + PARTE 2
    espadachin.set_prototype(guerrero)
    espadachin.set_property(:habilidad, 0.5)
    espadachin.set_property(:potencial_espada, 30)
    espadachin.energia = 100
    
    espadachin.potencial_ofensivo = 0
    
    espadachin.set_method(:potencial_ofensivo, proc {
      @potencial_ofensivo + self.potencial_espada * self.habilidad
    })
    espadachin.atacar_a(otro_guerrero)
    expect(otro_guerrero.energia).to eq(75)
    
    guerrero.set_method(:sanar, proc {
      self.energia = self.energia + 10
    })
    espadachin.sanar
    expect(espadachin.energia).to eq(110)


  end

  it 'Resolviendo parte 1 del enunciado mas parte 2 mas 3' do
    #PARTE 1
    guerrero.set_property(:energia, 100)
    expect(guerrero.energia).to eq(100)

    guerrero.set_property(:potencial_defensivo, 10)
    guerrero.set_property(:potencial_ofensivo, 30)
    guerrero.set_method(:atacar_a, proc { |otro_guerrero|
      if(otro_guerrero.potencial_defensivo < self.potencial_ofensivo)
        otro_guerrero.recibe_danio(self.potencial_ofensivo - otro_guerrero.potencial_defensivo)
      end
    })
    guerrero.set_method(:recibe_danio, proc { |danio|
      self.energia = self.energia - danio
    })

    otro_guerrero = guerrero.clone
    guerrero.atacar_a otro_guerrero

    expect(otro_guerrero.energia).to eq(80)

    # + PARTE 2
    espadachin.set_prototype(guerrero)
    espadachin.set_property(:habilidad, 0.5)
    espadachin.set_property(:potencial_espada, 30)
    espadachin.energia = 100
    
    espadachin.potencial_ofensivo = 0
    
    espadachin.set_method(:potencial_ofensivo, proc {
      @potencial_ofensivo + self.potencial_espada * self.habilidad
    })
    espadachin.atacar_a(otro_guerrero)
    expect(otro_guerrero.energia).to eq(75)
    

    # + PARTE 3
    guerrero.set_method(:sanar, proc {
      self.energia = self.energia + 10
    })
    espadachin.sanar
    expect(espadachin.energia).to eq(110)
    
  end

end