# Changelog

## v0.0.1.alpha

*Versión inicial*

* La clase **IdEcuador::Id** valida cédulas, RUCs

## v0.0.1.beta

* Agregado `IdEcuador.new` como alias de `IdEcuador::Id.new`
* Verificando que cuando un modelo en rails utiliza el validador, no se vuelva a instanciar otro validador a menos que la identificación (atributo) del mismo cambie.
* Agregado `factory_girl` para testing
* Tests refactored
* Modificado *Railtie*. Había un error de sintaxis. Reemplazado `intializer` por `initializer`

## v0.0.1

* Primera versión estable
* Pequeños arreglos de bugs en la implementación para Rails

## v0.0.2.alpha

* Agregados los métodos `id` y `id=` a la clase `IdEcuador::Id`
* Refactorizado el método `initialize` y `id=` para que ambos utilicen un nuevo método `evaluate!` y evitar duplicación de código
