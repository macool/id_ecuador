# IdEcuador

Gema para validar la cédula o ruc de Ecuador

## Status

[![Build Status](https://travis-ci.org/macool/id_ecuador.png?branch=master)](https://travis-ci.org/macool/id_ecuador)
[![Gem Version](https://badge.fury.io/rb/id_ecuador.png)](http://badge.fury.io/rb/id_ecuador)

## Installation

Add this line to your application's Gemfile:

    gem 'id_ecuador'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install id_ecuador

## Usage

```ruby
require "id_ecuador"

cedula = IdEcuador::Id.new "1104680135"
cedula.valid?           # => true
cedula.tipo_id          # => "Cédula Persona natural"
cedula.codigo_provincia # => 11

cedula_invalida = IdEcuador::Id.new "1105680134"
cedula_invalida.errors # => ["ID inválida"]
```

No validar automáticamente:

```ruby
cedula = IdEcuador::Id.new "1104680135", auto_validate: false
cedula.validate!.valid?
```

## Rails

```ruby
class User < ActiveRecord::Base
  validates_id :identificacion
end
```

Con opciones:

```ruby
class User < ActiveRecord::Base
  validates_id :identificacion, allow_blank: false, message: "Cédula inválida", only: [:cedula, :ruc]
end
```

Ejemplo API Rails:

```ruby
user = User.new identificacion: "110468135001"
user.identificacion_id_validator.class # => IdEcuador::Id
user.identificacion_tipo_id            # => "RUC Persona natural"
user.identificacion_codigo_provincia   # => 11
```

## TODO

- [ ] Documentar
- [ ] Escribir la documentación en un solo idioma

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
