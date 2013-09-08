module IdEcuador
  # extend <tt>IdEcuador::ModelAdditions</tt> module into Rails' <tt>ActiveRecord::Base</tt>
  class Railtie < Rails::Railtie
    intializer 'id_ecuador.model_additions' do
      ActiveSupport.on_load :active_record do
        extend ModelAdditions
      end
    end
  end
end
