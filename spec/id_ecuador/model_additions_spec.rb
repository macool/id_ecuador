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
      expect(user.save).to be true
    end

    describe "cache on #attribute_id_validator" do
      it "debería decir que el id del objeto que retorna el método es el mismo mientras la identificación no cambie" do
        user = FactoryGirl.build :user
        id = user.identificacion_id_validator.object_id
        expect(user.identificacion_id_validator.object_id).to eq(id)
      end
      it "no debería expirar el caché si se reasigna el mismo ID" do
        user = FactoryGirl.build :user
        id = user.identificacion_id_validator.object_id
        user.identificacion = FactoryGirl.attributes_for(:user)[:identificacion]
        expect(user.identificacion_id_validator.object_id).to eq(id)
      end
      it "debería expirar el caché si se reasigna otro ID" do
        user = FactoryGirl.build :user
        id = user.identificacion_id_validator.object_id
        user.identificacion = FactoryGirl.attributes_for(:user_invalid)[:identificacion]
        expect(user.identificacion_id_validator.object_id).to_not eq(id)
      end
    end

    describe "valida el ID de un usuario antes de guardarlo a la base de datos" do
      it "debería decir que es válido" do
        expect(FactoryGirl.build :user).to be_valid
      end
      it "debería decir que es inválido" do
        user = FactoryGirl.build(:user_invalid)
        expect(user.save).to be false
        expect(user.errors[:identificacion]).to include("ID inválida")
      end
      it "debería decir que la longitud es inválida" do
        user = User.new(identificacion: "12345")
        expect(user.save).to be false
        expect(user.errors[:identificacion]).to include("Longitud incorrecta")
      end

      describe "expirar el cache de la variable @id_ecuador_validator_last_id" do
        it "debería decir que la cédula es válida y, al cambiarla, decir que es inválida" do
          user = User.new
          user.identificacion = "1104680135"
          expect(user).to be_valid
          user.identificacion = "1104680134"
          expect(user).to_not be_valid
        end
        it "debería decir que la cédula es inválida y, al cambiarla, decir que es válida" do
          user = User.new
          user.identificacion = "1104680134"
          expect(user).to_not be_valid
          user.identificacion = "1104680135"
          expect(user).to be_valid
        end
      end

    end

    describe "debe agregar métodos al atributo" do
      it "debe agregar método `identificacion_tipo_id`" do
        user = FactoryGirl.build(:user)
        expect(user).to respond_to :identificacion_tipo_id
        expect(user.identificacion_tipo_id).to eq("Cédula Persona natural")
      end
      it "debe agregar método `identificacion_codigo_provincia`" do
        user = FactoryGirl.build(:user)
        expect(user).to respond_to :identificacion_codigo_provincia
        expect(user.identificacion_codigo_provincia).to eq(11)
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
        expect(user).to_not be_valid
        expect(user.errors[:identificacion]).to include("No puede quedar en blanco")
      end
    end

    describe "specify message" do
      class UserWithOptionsMessage < SuperModel::Base
        extend IdEcuador::ModelAdditions
        validates_id :identificacion, allow_blank: false, message: "Not valid!"
      end

      it "debería mostrar 'Not valid!' como error con identificacion nil" do
        user = UserWithOptionsMessage.new identificacion: nil
        expect(user).to_not be_valid
        expect(user.errors[:identificacion]).to eq(["Not valid!"])
      end
      it "debería mostrar 'Not valid!' como error con cédula" do
        user = UserWithOptionsMessage.new FactoryGirl.attributes_for(:user_invalid)
        expect(user).to_not be_valid
        expect(user.errors[:identificacion]).to eq(["Not valid!"])
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
          expect(user).to be_valid
        end
        it "debería decir que es válido con blank" do
          user = UserWithOptionsOnlyCedula.new identificacion: nil
          expect(user).to be_valid
        end
        it "debería decir que es inválido" do
          user = UserWithOptionsOnlyCedula.new FactoryGirl.attributes_for(:user_ruc)
          expect(user).to_not be_valid
          expect(user.errors[:identificacion]).to include("Tipo de identificación no permitido")
        end
      end
      describe "con RUC" do
        class UserWithOptionsOnlyRUC < SuperModel::Base
          extend IdEcuador::ModelAdditions
          validates_id :identificacion, only: :ruc
        end
        it "debería decir que es válido" do
          user = UserWithOptionsOnlyRUC.new FactoryGirl.attributes_for(:user_ruc)
          expect(user).to be_valid
        end
        it "debería decir que es inválido" do
          user = UserWithOptionsOnlyRUC.new FactoryGirl.attributes_for(:user)
          expect(user).to_not be_valid
          expect(user.errors[:identificacion]).to include("Tipo de identificación no permitido")
        end
      end
      describe "permitir RUC y cédula sin blank" do
        class UserWithRucCiNotBlank < SuperModel::Base
          extend IdEcuador::ModelAdditions
          validates_id :identificacion, only: [:ruc, :cedula], allow_blank: false
        end

        it "Con cédula" do
          user = UserWithRucCiNotBlank.new FactoryGirl.attributes_for(:user)
          expect(user).to be_valid
        end
        it "Con ruc" do
          user = UserWithRucCiNotBlank.new FactoryGirl.attributes_for(:user_ruc)
          expect(user).to be_valid
        end
        it "Con ID nil" do
          user = UserWithRucCiNotBlank.new identificacion: nil
          expect(user).to_not be_valid
        end
      end
    end
  end

end
