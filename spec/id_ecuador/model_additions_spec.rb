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
        FactoryGirl.build(:user).valid?.should be_true
      end
      it "debería decir que es inválido" do
        user = FactoryGirl.build(:user_invalid)
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
        user = FactoryGirl.build(:user)
        user.respond_to?(:identificacion_tipo_id).should be_true
        user.identificacion_tipo_id.should eq("Cédula Persona natural")
      end
      it "debe agregar método `identificacion_codigo_provincia`" do
        user = FactoryGirl.build(:user)
        user.respond_to?(:identificacion_codigo_provincia).should be_true
        user.identificacion_codigo_provincia.should eq(11)
      end
    end
  end

  describe "with options" do
    describe "don't allow_blank" do
      class UserWithOptionsAllowBlank < SuperModel::Base
        extend IdEcuador::ModelAdditions
        validates_id :identificacion, allow_blank: false
      end

      it "should say record is invalid as identificacion is blank" do
        user = UserWithOptionsAllowBlank.new identificacion: nil
        user.valid?.should be_false
        user.errors[:identificacion].should include("No puede quedar en blanco")
      end
    end
    
    describe "specify message" do
      class UserWithOptionsMessage < SuperModel::Base
        extend IdEcuador::ModelAdditions
        validates_id :identificacion, allow_blank: false, message: "Not valid!"
      end

      it "debería mostrar 'Not valid!' como error con identificacion nil" do
        user = UserWithOptionsMessage.new identificacion: nil
        user.valid?.should be_false
        user.errors[:identificacion].should eq(["Not valid!"])
      end
      it "debería mostrar 'Not valid!' como error con cédula" do
        user = UserWithOptionsMessage.new FactoryGirl.attributes_for(:user_invalid)
        user.valid?.should be_false
        user.errors[:identificacion].should eq(["Not valid!"])
      end
    end
    describe "specify only options" do
      describe "con cédula" do
        class UserWithOptionsOnlyCedula < SuperModel::Base
          extend IdEcuador::ModelAdditions
          validates_id :identificacion, only: :cedula
        end

        it "debería decir que es válido" do
          user = UserWithOptionsOnlyCedula.new FactoryGirl.attributes_for(:user)
          user.valid?.should be_true
        end
        it "debería decir que es inválido" do
          user = UserWithOptionsOnlyCedula.new FactoryGirl.attributes_for(:user_ruc)
          user.valid?.should be_false
          user.errors[:identificacion].should include("Tipo de identificación no permitido")
        end
      end
      describe "con RUC" do
        class UserWithOptionsOnlyRUC < SuperModel::Base
          extend IdEcuador::ModelAdditions
          validates_id :identificacion, only: :ruc
        end
        it "debería decir que es válido" do
          user = UserWithOptionsOnlyRUC.new FactoryGirl.attributes_for(:user_ruc)
          user.valid?.should be_true
        end
        it "debería decir que es inválido" do
          user = UserWithOptionsOnlyRUC.new FactoryGirl.attributes_for(:user)
          user.valid?.should be_false
          user.errors[:identificacion].should include("Tipo de identificación no permitido")
        end
      end
    end
  end

end
