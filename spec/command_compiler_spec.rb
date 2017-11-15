require "spec_helper"

RSpec.describe Figobox::CommandCompiler do
  describe "#new" do
    it "sets an empty hash of variables by default" do
      compiler = Figobox::CommandCompiler.new("local", nil)

      expect(compiler.instance_variable_get(:@variables)).to eq({})
    end
  end

  describe "#add" do
    it "returns an empty string if there are no variables to set" do
      target_alias = "local"
      variables = {}
      compiler = Figobox::CommandCompiler.new(target_alias, variables)

      expect(compiler.add).to eq("")
    end

    it "returns one command setting all of the variables" do
      target_alias = "local"
      variables = { "KEY" => "val", "KEY2" => "val2" }
      compiler = Figobox::CommandCompiler.new(target_alias, variables)

      expect(compiler.add).to eq("nanobox evar add local KEY=val KEY2=val2")
    end
  end
end
