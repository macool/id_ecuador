module IdEcuador
  module ModelAdditions
    def validates_id(attribute, options={})
      defaults = {
        allow_blank: true,
        message: nil
      }
      options = defaults.merge options

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
          errors.add attribute.to_sym, options[:message] or "No puede quedar en blanco"
        else
          if not send(:"#{attribute}").blank? and not send(:"#{attribute}_id_validator").valid?
            send(:"#{attribute}_id_validator").errors.each do |error|
              errors.add attribute.to_sym, error
            end
          end
        end
      end

    end
  end
end
