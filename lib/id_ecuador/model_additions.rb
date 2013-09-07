module IdEcuador
  module ModelAdditions
    def validates_id(attribute)
      validate do
        id = IdEcuador::Id.new(send(attribute))
        unless id.valid?
          id.errors.each do |error|
            errors.add attribute.to_sym, error
          end
        end
      end
    end
  end
end
