# encoding: utf-8
require "spec_helper"

describe IdEcuador::Id do

  describe "interfaz de la clase" do
    it "debe llamar automáticamente al método validate!" do
      expect_any_instance_of(IdEcuador::Id).to receive(:validate!)
      IdEcuador::Id.new CEDULA_VALIDA
    end

    it "no debe llamar automáticamente al método validate!" do
      expect_any_instance_of(IdEcuador::Id).to_not receive(:validate!)
      IdEcuador::Id.new CEDULA_VALIDA, auto_validate: false
    end

    it "debe volver a correr la validación si cambia el ID con el método #id= y options[:auto_validate] está puesto" do
      id = IdEcuador::Id.new
      expect(id).to receive(:validate!)
      id.id = CEDULA_VALIDA
    end

    it "no debe correr la validación si cambia el ID y options[:auto_validate] es false" do
      id = IdEcuador::Id.new "", auto_validate: false
      expect(id).to_not receive(:validate!)
      id.id = CEDULA_VALIDA
    end

    it "el método #id= no debe dañar el resto de la funcionalidad" do
      id = IdEcuador::Id.new ""
      id.id = CEDULA_VALIDA
      expect(id).to be_valid
      id.id = CEDULA_INVALIDA
      expect(id).to_not be_valid
    end
  end

  describe "funcionalidad de la clase" do
    describe "longitud" do
      # longitud debería ser 10 para cédulas y 13 para RUC
      before :each do
        @error = "Longitud incorrecta"
      end

      it "debería fallar con longitud menor a 10 caracteres" do
        id = IdEcuador::Id.new "11"
        expect(id.errors).to include(@error)
      end

      it "no debería incluir problemas de longitud con 10 caracteres" do
        id = IdEcuador::Id.new CEDULA_VALIDA
        expect(id.errors).to_not include(@error)
      end

      it "no debería incluir problemas de longitud con 13 caracteres" do
        id = IdEcuador::Id.new RUC_VALIDO
        expect(id.errors).to_not include(@error)
      end

      it "debería fallar con longitud mayor a 13 caracteres" do
        id = IdEcuador::Id.new "12345678910111213"
        expect(id.errors).to include(@error)
      end
    end

    describe "código de provincia" do
      # Hay 22 provincias. Los dos primeros dígitos son el código de la provincia. Debe ser mayor a 0 y menor a 22
      it "debería fallar con código de provincia 23" do
        id = IdEcuador::Id.new "2304680135"
        expect(id.errors).to include("Código de provincia incorrecto")
      end

      it "debería decir que el código de la provincia es 11" do
        id = IdEcuador::Id.new CEDULA_VALIDA
        expect(id.codigo_provincia).to eq(11)
      end
    end

    describe "tercer dígito" do
      # el tercer dígito no puede ser el número 7 ni 8
      before :each do
        @error = "Tercer dígito es inválido"
      end

      it "debería fallar con tercer dígito 7" do
        id = IdEcuador::Id.new "1174680135"
        expect(id.errors).to include(@error)
      end

      it "debería fallar con tercer dígito 8" do
        id = IdEcuador::Id.new "1184680135"
        expect(id.errors).to include(@error)
      end
    end

    describe "tipo de identificación" do
      # con tercer dígito:
      #   9    -> sociedades privadas o extranjeras
      #   6    -> sociedades públicas
      #   0..5 -> personas naturales
      it "debería decir que es una persona natural" do
        id = IdEcuador::Id.new CEDULA_VALIDA
        expect(id.tipo_id).to eq("Cédula Persona natural")
      end

      it "debería decir que es el RUC de una persona natural" do
        id = IdEcuador::Id.new RUC_VALIDO
        expect(id.tipo_id).to eq("RUC Persona natural")
      end

      it "debería decir que es una sociedad pública" do
        id = IdEcuador::Id.new "1164680130001"
        expect(id.tipo_id).to eq("Sociedad pública")
      end

      it "debería decir que es una sociedad privada o extranjera" do
        id = IdEcuador::Id.new "1194680135001"
        expect(id.tipo_id).to eq("Sociedad privada o extranjera")
      end
    end

    describe "probar con algunas cédulas" do
      it "debería decir que esta cédula es válida" do
        expect(IdEcuador::Id.new CEDULA_VALIDA).to be_valid
      end

      it "debería decir que esta cédula es inválida" do
        expect(IdEcuador::Id.new CEDULA_INVALIDA).to_not be_valid
      end

      it "debería decir que estas cédulas son válidas" do
        ["1104077209",
         "1102077425",
         "1102019351",
         "1102778014"].each do |cedula|
           expect(IdEcuador::Id.new cedula).to be_valid
         end
      end
    end
  end
end
