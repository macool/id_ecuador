# encoding: utf-8

module IdEcuador
  class Id
    
    attr_reader :errors, :tipo_id, :result
    
    def initialize(id, options={})
      @id = id.to_s
      @errors = []
      @result = {}
      
      defaults = {
        auto_validate: true
      }
      @options = defaults.merge options
      validate! if @options[:auto_validate]
    end
    def valid?
      validate! unless already_validated
      @errors.empty?
    end
    def validate!
      @already_validated = true
      validate_length and evaluate_province_code and evaluate_third_digit and 
    end
    
  protected
    def already_validated
      !!@already_validated
    end
    
  private
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
        @result[:codigo_provincia] = code
        true
      end
    end
    def evaluate_third_digit
      @third_digit = @id[2].to_i
      if [7, 8].include?(@third_digit)
        @errors << "Tercer dígito es inválido"
        return false
      elsif @third_digit < 6
        @tipo_id = "Persona natural"
      elsif @third_digit == 6
        @tipo_id = "Sociedad pública"
      elsif @third_digit == 9
        @tipo_id = "Sociedad privada o extranjera"
      end
      return true
    end
  end
end










