# encoding: utf-8
require "spec_helper"

describe IdEcuador do
  it "should alias IdEcuador#new to IdEcuador::Id#new" do
    id = IdEcuador.new "1104680135"
    id.class.should eq(IdEcuador::Id)
  end
end
