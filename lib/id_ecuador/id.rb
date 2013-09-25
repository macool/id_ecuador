# encoding: utf-8

module IdEcuador
  # Clase que va a analizar la cédula. Recibe un id y unas opciones
  # @attr_reader [String] id Número de ID
  # @attr_reader [Array] errors Los errores que tiene el ID. Array vacío si es un ID válido
  #
  # @attr_reader [String] tipo_id El tipo de identificación. Puede ser:
  #   - "Cédula Persona natural"
  #   - "RUC Persona natural"
  #   - "Sociedad pública"
  #   - "Sociedad privada o extranjera"
  #
  # @attr_reader [Symbol] tipo_id_sym El tipo de identificación en símbolo. Puede ser:
  #   - :ruc
  #   - :cedula
  #   - :sociedad_publica
  #   - :sociedad_privada
  #
  # @attr_reader [Fixnum] codigo_provincia El código de la provincia del ID ingresado
  class Id
    
    attr_reader :id, :errors, :tipo_id, :tipo_id_sym, :codigo_provincia
    
    # @param [String] id El ID que se va a analizar
    # @param [Hash] options Las opciones
    # @option options [Boolean] :auto_validate Validar automáticamente el ID al instanciar. <tt>true</tt> por defecto
    def initialize(id="", options={})
      @id = id.to_s
      
      defaults = {
        auto_validate: true
      }
      @options = defaults.merge options
      evaluate!
    end

    # Setter para el ID
    # @param [String] new_id Nuevo ID que se va a analizar
    # @return [String] Nuevo ID
    def id=(new_id)
      @id = new_id.to_s
      evaluate!
      new_id
    end

    # @return [Boolean] Si es un ID válido o no
    def valid?
      validate! unless already_validated
      @errors.empty?
    end

    # @return [self] Método que valida
    def validate!
      @already_validated = true
      validate_length and evaluate_province_code and evaluate_third_digit
      self
    end

    # @return [Boolean] Si el ID ya ha sido validado
    def already_validated
      !!@already_validated
    end
    
  protected
    # Método llamado después de #initialize y #id=
    # Se encarga de correr la validación si options[:auto_validate] es true
    def evaluate!
      @errors = []
      validate! if @options[:auto_validate]
      self
    end
    def validate_length
      if [10, 13].include?(@id.length)
        true
      else
        @errors << "Longitud incorrecta"
        false
      end
    end
    def evaluate_province_code
      provinces = 22
      code = @id.slice(0,2).to_i
      if code < 1 or code > provinces
        @errors << "Código de provincia incorrecto"
        false
      else
        @codigo_provincia = code
        true
      end
    end
    def evaluate_third_digit
      @third_digit = @id[2].to_i

      # to keep products in next method:
      @products = []

      if [7, 8].include?(@third_digit)
        @errors << "Tercer dígito es inválido"
        return false
      elsif @third_digit < 6
        if @id.length > 10
          @tipo_id = "RUC Persona natural"
          @tipo_id_sym = :ruc
        else
          @tipo_id = "Cédula Persona natural"
          @tipo_id_sym = :cedula
        end
        validate_last_digits_for_persona_natural and evaluate_sums_for_persona_natural!
      elsif @third_digit == 6
        @tipo_id = "Sociedad pública"
        @tipo_id_sym = :sociedad_publica
        validate_last_digits_for_sociedad_publica and evaluate_sums_for_sociedad_publica!
      elsif @third_digit == 9
        @tipo_id = "Sociedad privada o extranjera"
        @tipo_id_sym = :sociedad_privada
        validate_last_digits_for_sociedad_privada and evaluate_sums_for_sociedad_privada!
      end
      return true
    end
    def validate_last_digits_for_persona_natural
      if @id.length > 10 and @id.slice(10,3) != "001"
        @errors << "RUC de persona natural debe terminar en 001"
        false
      else
        true
      end
    end
    def validate_last_digits_for_sociedad_publica
      if @id.slice(9,4) != "0001"
        @errors << "RUC de empresa de sector público debe terminar en 0001"
        false
      else
        true
      end
    end
    def validate_last_digits_for_sociedad_privada
      if @id.slice(10,3) != "001"
        @errors << "RUC de entidad privada o extranjera debe terminar en 001"
        false
      else
        true
      end
    end
    def evaluate_sums_for_persona_natural!
      @modulus = 10
      @verifier = @id.slice(9,1).to_i
      p = 2
      @id.slice(0,9).chars do |c|
        product = c.to_i * p
        if product >= 10 then product -= 9 end
        @products << product
        p = if p == 2 then 1 else 2 end
      end
      do_sums!
      self
    end
    def evaluate_sums_for_sociedad_publica!
      @modulus = 11
      @verifier = @id.slice(8,1).to_i
      multipliers = [3, 2, 7, 6, 5, 4, 3, 2]
      (0..7).each do |i|
        @products[i] = @id[i].to_i * multipliers[i]
      end
      @products[8] = 0
      do_sums!
      self
    end
    def evaluate_sums_for_sociedad_privada!
      @modulus = 11
      @verifier = @id.slice(9,1).to_i
      multipliers = [4, 3, 2, 7, 6, 5, 4, 3, 2]
      (0..8).each do |i|
        @products[i] = @id[i].to_i * multipliers[i]
      end
      do_sums!
      self
    end
    def do_sums!
      sum = 0
      @products.each do |product|
        sum += product
      end
      res = sum % @modulus
      digit = if res == 0 then 0 else @modulus - res end
      unless digit == @verifier
        @errors << "ID inválida"
      end
      self
    end
  end
end
