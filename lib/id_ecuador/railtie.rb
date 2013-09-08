module IdEcuador
  # extend <tt>IdEcuador</tt> module into Rails' <tt>ActiveRecord::Base</tt>
  # Permite llamar a <tt>validates_id</tt> dentro de un modelo de Rails
  class Railtie < Rails::Railtie
    intializer 'id_ecuador.model_additions' do
      ActiveSupport.on_load :active_record do
        extend ModelAdditions
      end
    end
  end
end
