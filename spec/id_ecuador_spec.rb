# encoding: utf-8
require "spec_helper"

describe IdEcuador do
  it "should alias IdEcuador#new to IdEcuador::Id#new" do
    id = IdEcuador.new CEDULA_VALIDA
    expect(id.class).to eq(IdEcuador::Id)
    expect(id.id).to eq(CEDULA_VALIDA)
  end
end
