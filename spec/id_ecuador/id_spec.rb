# encoding: utf-8
require "spec_helper"

describe IdEcuador::Id do
  
  describe "interfaz de la clase" do
    it "debe llamar automáticamente al método validate!" do
      id = IdEcuador::Id.new("1104680135")
      id.send(:already_validated).should be_true
    end
    it "no debe llamar automáticamente al método validate!" do
      IdEcuador::Id.any_instance.stub(:validate!)
      id = IdEcuador::Id.new("1104680135", validate: false)
      id.send(:already_validated).should be_false
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
        id.errors.should include(@error)
      end
      it "no debería incluir problemas de longitud con 10 caracteres" do
        id = IdEcuador::Id.new "1104680135"
        id.errors.should_not include(@error)
      end
      it "no debería incluir problemas de longitud con 13 caracteres" do
        id = IdEcuador::Id.new "1104680135001"
        id.errors.should_not include(@error)
      end
      it "debería fallar con longitud mayor a 13 caracteres" do
        id = IdEcuador::Id.new "12345678910111213"
        id.errors.should include(@error)
      end
    end
  
    describe "código de provincia" do
      # Hay 22 provincias. Los dos primeros dígitos son el código de la provincia. Debe ser mayor a 0 y menor a 22
      it "debería fallar con código de provincia 23" do
        id = IdEcuador::Id.new "2304680135"
        id.errors.should include("Código de provincia incorrecto")
      end
    end
  
    describe "tercer dígito" do
      # el tercer dígito no puede ser el número 7 ni 8
      before :each do
        @error = "Tercer dígito es inválido"
      end
    
      it "debería fallar con tercer dígito 7" do
        id = IdEcuador::Id.new "1174680135"
        id.errors.should include(@error)
      end
      it "debería fallar con tercer dígito 8" do
        id = IdEcuador::Id.new "1184680135"
        id.errors.should include(@error)
      end
    end
  
    describe "tipo de identificación" do
      # con tercer dígito:
      #   9    -> sociedades privadas o extranjeras
      #   6    -> sociedades públicas
      #   0..5 -> personas naturales
      it "debería decir que es una persona natural" do
        id = IdEcuador::Id.new "1104680135"
        id.tipo_id.should eq("Persona natural")
      end
      it "debería decir que es una sociedad pública" do
        id = IdEcuador::Id.new "1164680130001"
        id.tipo_id.should eq("Sociedad pública")
      end
      it "debería decir que es una sociedad privada o extranjera" do
        id = IdEcuador::Id.new "1194680135001"
        id.tipo_id.should eq("Sociedad privada o extranjera")
      end
    end
  
    describe "probar con algunas cédulas" do
      it "debería decir que esta cédula es válida" do
        IdEcuador::Id.new("1104680135").valid?.should be_true
      end
      it "debería decir que esta cédula es inválida" do
        IdEcuador::Id.new("1104680134").valid?.should be_false
      end
      it "debería decir que estas cédulas son válidas" do
        ["1104077209",
         "1102077425",
         "1102019351",
         "1102778014"].each do |cedula|
           IdEcuador::Id.new(cedula).valid?.should be_true
         end
      end
    end
  end
end
