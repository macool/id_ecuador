# encoding: utf-8
require "spec_helper"

# tests with Rails' models

describe IdEcuador::ModelAdditions do

  describe "with no options" do
    class User < SuperModel::Base
      extend IdEcuador::ModelAdditions
      validates_id :identificacion
    end

    it "no debería levantar un error si la identificacion del usuario no está puesta" do
      user = User.new identificacion: nil
      user.save.should be_true
    end

    describe "valida el ID de un usuario antes de guardarlo a la base de datos" do
      it "debería decir que es válido" do
        User.new(identificacion: "1104680135").valid?.should be_true
      end
      it "debería decir que es inválido" do
        user = User.new(identificacion: "1104680134")
        user.save.should be_false
        user.errors[:identificacion].should include("ID inválida")
      end
      it "debería decir que la longitud es inválida" do
        user = User.new(identificacion: "12345")
        user.save.should be_false
        user.errors[:identificacion].should include("Longitud incorrecta")
      end

      describe "expirar el cache de la variable @id_ecuador_validator_last_id" do
        it "debería decir que la cédula es válida y, al cambiarla, decir que es inválida" do
          user = User.new
          user.identificacion = "1104680135"
          user.valid?.should be_true
          user.identificacion = "1104680134"
          user.valid?.should be_false
        end
        it "debería decir que la cédula es inválida y, al cambiarla, decir que es válida" do
          user = User.new
          user.identificacion = "1104680134"
          user.valid?.should be_false
          user.identificacion = "1104680135"
          user.valid?.should be_true
        end
      end

    end

    describe "debe agregar métodos al atributo" do
      it "debe agregar método `identificacion_tipo_id`" do
        user = User.new(identificacion: "1104680135")
        user.respond_to?(:identificacion_tipo_id).should be_true
        user.identificacion_tipo_id.should eq("Cédula Persona natural")
      end
      it "debe agregar método `identificacion_codigo_provincia`" do
        user = User.new(identificacion: "1104680135")
        user.respond_to?(:identificacion_codigo_provincia).should be_true
        user.identificacion_codigo_provincia.should eq(11)
      end
    end
  end

  describe "with options" do
    describe "allow_blank" do
      
      class User < SuperModel::Base
        extend IdEcuador::ModelAdditions
        validates_id :identificacion, allow_blank: true
      end



    end
  end

end
