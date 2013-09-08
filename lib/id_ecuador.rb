require "id_ecuador/version"
require "id_ecuador/id"
require "id_ecuador/model_additions"
require "id_ecuador/railtie" if defined? Rails

# Este módulo debe servir como <em>namespace</em>
#
# @author macool <a@macool.me>
#
# Contiene:
# Clases:
# * <tt>Id</tt>
#
# Módulos:
# * <tt>ModelAdditions</tt>
# * <tt>Railtie</tt>
module IdEcuador

  # Alias al método #new de la clase IdEcuador::Id
  # @example Instanciar ID
  #   IdEcuador.new("1104680135").class #=> IdEcuador::Id
  def self.new(*args)
    IdEcuador::Id.new(*args)
  end
end
