require 'rspec'
require_relative '../lib/prototyped'
require_relative '../lib/prototyped_object'
require_relative '../lib/prototyped_constructor'
require_relative '../lib/father_constructor'
require_relative '../lib/of_prototyped_obj_constructor'
require_relative '../lib/copy_constructor'
require_relative '../lib/extend_constructor'

describe 'Constructors' do

  let :guerrero do
    guerrero = PrototypedObject.new
    guerrero.set_property(:energia, 100)
    guerrero.set_property(:potencial_defensivo, 20)
    guerrero.set_property(:potencial_ofensivo, 50)
    guerrero
  end

  it 'Ejemplo constructor sencillo' do
    otro_guerrero = PrototypedConstructor.new(guerrero)
    un_guerrero = otro_guerrero.new(
      {energia: 100, potencial_ofensivo: 30, potencial_defensivo: 10}
    )
    expect(un_guerrero.potencial_ofensivo).to eq(30)
  end

  it 'Copy' do
    guerrero_copy_constructor = PrototypedConstructor.copy(guerrero)
    un_guerrero = guerrero_copy_constructor.new
    expect(un_guerrero.energia).to eq(100)
    expect(un_guerrero.potencial_ofensivo).to eq(50)
    expect(un_guerrero.potencial_defensivo).to eq(20)
  end

  it 'Of prototyped obj constructor' do
    guerrero_of_prototypedObj_constructor = PrototypedConstructor.new(guerrero)
    un_guerrero = guerrero_of_prototypedObj_constructor.new(
        {energia: 100, potencial_ofensivo: 30, potencial_defensivo: 10}
    )
    expect(un_guerrero.potencial_ofensivo).to eq(30)

    espadachin_constructor = guerrero_of_prototypedObj_constructor.extended {
        |espadachin, habilidad, potencial_espada|
      espadachin.set_property(:habilidad, habilidad)
      espadachin.set_property(:potencial_espada, potencial_espada)
      espadachin.set_method(:potencial_ofensivo, proc {
        @potencial_ofensivo + self.potencial_espada * self.habilidad
      })
    }

    espadachin = espadachin_constructor.new({energia: 100, potencial_ofensivo: 30, potencial_defensivo: 10}, 0.5, 30)
    expect(espadachin.potencial_ofensivo).to eq(45)
  end

end