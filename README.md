# IdEcuador

Gema para validar la cédula o ruc de Ecuador

La clase `Id` dentro del módulo `IdEcuador` permite, a partir de un número de identificación, saber:

- Si el número de identificación es válido
- El tipo de identificación, que puede ser:
    - Cédula
    - RUC personas naturales
    - RUC empresa sector público
    - RUC empresa privada o extranjera

## Status

[![Build Status](https://travis-ci.org/macool/id_ecuador.png?branch=master)](https://travis-ci.org/macool/id_ecuador)
[![Gem Version](https://badge.fury.io/rb/id_ecuador.png)](http://badge.fury.io/rb/id_ecuador)

## Usage

```ruby
require "id_ecuador"

cedula = IdEcuador.new "1104680135"
cedula.id               # => "1104680135"
cedula.valid?           # => true
cedula.tipo_id          # => "Cédula Persona natural"
cedula.tipo_id_sym      # => :cedula
cedula.codigo_provincia # => 11

cedula_invalida = IdEcuador.new "1105680134"
cedula_invalida.errors # => ["ID inválida"]
```

No validar automáticamente:

```ruby
cedula = IdEcuador.new "1104680135", auto_validate: false
cedula.validate!.valid?
```

## Rails

```ruby
class User < ActiveRecord::Base
  validates_id :identificacion
end
```

### Con opciones:

Las opciones por defecto son:

```ruby
{
  :allow_blank => true,   # No levanta error si el atributo es nil o ""
  :message => nil,        # Utilizar mensajes por defecto de la gema
  :only => []             # Permitir todos los tipos de ID
}
```

```ruby
class User < ActiveRecord::Base
  validates_id :identificacion, allow_blank: false, message: "Cédula inválida", only: [:cedula, :ruc]
end
```

Ejemplo API Rails:

```ruby
user = User.new identificacion: "110468135001"
user.idenfiticacion                    # => "110468135001"
user.identificacion_id_validator.class # => IdEcuador::Id
user.identificacion_tipo_id            # => "RUC Persona natural"
user.identificacion_tipo_id_sym        # => :ruc
user.identificacion_codigo_provincia   # => 11
```

## Installation

Add this line to your application's Gemfile:

    gem 'id_ecuador'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install id_ecuador

## Documentación

[rubydoc](http://rubydoc.info/github/macool/id_ecuador/master/frames)

## TODO

- [ ] Documentar
- [ ] Escribir la documentación en un solo idioma

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
