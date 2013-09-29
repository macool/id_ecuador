# encoding: utf-8
require "spec_helper"

describe IdEcuador do
  it "should alias IdEcuador#new to IdEcuador::Id#new" do
    id = IdEcuador.new CEDULA_VALIDA
    id.class.should eq(IdEcuador::Id)
    id.id.should eq(CEDULA_VALIDA)
  end
end
