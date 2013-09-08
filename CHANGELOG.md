# Changelog

## v0.0.1.alpha

*Versión inicial*

* La clase **IdEcuador::Id** valida cédulas, RUCs

## v0.0.1.beta

* Agregado `IdEcuador.new` como alias de `IdEcuador::Id.new`
* Verificando que cuando un modelo en rails utiliza el validador, no se vuelva a instanciar otro validador a menos que la identificación (atributo) del mismo cambie.
* Agregado `factory_girl` para testing
* Tests refactored

## v0.0.1.beta.2

* Modificado *Railtie*. Había un error de sintaxis. Reemplazado `intializer` por `initializer`
