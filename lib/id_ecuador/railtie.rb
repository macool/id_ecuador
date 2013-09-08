module IdEcuador
  class Railtie < Rails::Railtie
    intializer 'id_ecuador.model_additions' do
      ActiveSupport.on_load :active_record do
        extend ModelAdditions
      end
    end
  end
end
