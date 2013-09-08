# encoding: utf-8

module IdEcuador
  # Módulo que agrega funcionalidad a los modelos de Rails
  # Permite llamar a <tt>validates_id</tt> dentro de un modelo de Rails
  module ModelAdditions

    # @param [Symbol] attribute atributo que va a validar IdEcuador::Id
    # @param [Hash] options opciones para la validación
    # @option options [Boolean] :allow_blank no poner errores si el atributo no está puesto
    # @option options [String] :message mensaje de error que se va a poner en el atributo
    # @option options [Array] :only tipos de ID que se va a permitir
    # options for :only
    # - :cedula
    # - :ruc
    # - :sociedad_publica
    # - :sociedad_privada
    def validates_id(attribute, options={})
      defaults = {
        allow_blank: true,
        message: nil,
        only: []
      }
      options = defaults.merge options

      # to array if not:
      unless options[:only].class == Array
        options[:only] = [options[:only]]
      end


      # poner métodos:

      # getter del atributo que siempre retorna una instancia de IdEcuador::Id y se encarga de hacer cache basado en el valor del atributo
      class_eval <<-EVAL
        def #{attribute}_id_validator
          if not @id_ecuador_validator or (send(:#{attribute}) != @id_ecuador_validator_last_id)
            @id_ecuador_validator = IdEcuador::Id.new(send(:#{attribute}))
            @id_ecuador_validator_last_id = send(:#{attribute})
          end
          @id_ecuador_validator
        end
      EVAL

      # extensiones para .tipo_id y .codigo_provincia
      class_eval <<-EVAL
        def #{attribute}_tipo_id
          #{attribute}_id_validator.tipo_id
        end
        def #{attribute}_codigo_provincia
          #{attribute}_id_validator.codigo_provincia
        end
      EVAL

      validate do
        if not options[:allow_blank] and send(:"#{attribute}").blank?
          errors.add attribute.to_sym, (options[:message] or "No puede quedar en blanco")
        else
          # normal validations:
          if not send(:"#{attribute}").blank? and not send(:"#{attribute}_id_validator").valid?
            if options[:message]
              errors.add attribute.to_sym, options[:message]
            else
              send(:"#{attribute}_id_validator").errors.each do |error|
                errors.add attribute.to_sym, error
              end
            end
          end
          # for options:
          unless options[:only].empty?
            unless options[:only].include?(send(:"#{attribute}_id_validator").tipo_id_sym)
              errors.add attribute.to_sym, (options[:message] or "Tipo de identificación no permitido")
            end
          end
        end
      end

    end
  end
end
