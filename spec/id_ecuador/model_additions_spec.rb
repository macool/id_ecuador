# encoding: utf-8
require "spec_helper"

# tests with Rails' models

describe IdEcuador::ModelAdditions do
  
  describe "tests con id" do
    
    class User < SuperModel::Base
      extend IdEcuador::ModelAdditions
      validates_id :identificacion
    end

    describe "valida el ID de un usuario antes de guardarlo a la base de datos" do
      it "debería decir que es válido" do
        User.new(identificacion: "1104680135").valid?.should be_true
      end
      it "debería decir que es inválido" do
        user = User.new(identificacion: "1104680134")
        user.valid?.should be_false
        user.errors[:identificacion].should include("ID inválida")
      end
      it "debería decir que la longitud es inválida" do
        user = User.new(identificacion: "12345")
        user.valid?.should be_false
        user.errors[:identificacion].should include("Longitud incorrecta")
      end
    end
  end

end
