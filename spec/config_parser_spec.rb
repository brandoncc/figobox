require "spec_helper"

RSpec.describe Figobox::ConfigParser do
  before do
    allow(File)
      .to receive(:read)
      .and_return(File.read(File.expand_path("#{File.dirname(__FILE__)}/fixtures/application.yml")))
  end

  describe "#new" do
    it "aborts with an error if no config file exists", :allow_abort do
      expect(File).to receive(:exists?).and_return(false)

      expect_any_instance_of(Kernel)
        .to receive(:abort)
        .with("No config file could be found at config/application.yml. Please see https://github.com/laserlemon/figaro for more details.")

      Figobox::ConfigParser.new
    end
  end

  describe "#get_keys_for_environment" do
    before { allow(File).to receive(:exists?).and_return(true) }

    it "aborts with an error if the specified environment doesn't exist", :allow_abort do
      expect_any_instance_of(Kernel)
        .to receive(:abort)
        .with("'fake' environment doesn't exist in the configuration file.")

      subject.get_keys_for_environment("fake")
    end

    it "includes keys that are not nested in an environment" do
      expect(subject.get_keys_for_environment("development"))
        .to have_key("GLOBAL_KEY")
    end

    it "does not include keys that are in a different environment" do
      expect(subject.get_keys_for_environment("development"))
        .not_to have_key("STAGING_KEY")
    end

    it "is not case sensitive" do
      expect(subject.get_keys_for_environment("dEvElOpMeNt"))
        .to have_key("DEVELOPMENT_KEY")
    end

    it "returns all of the keys in the correct environment" do
      result = subject.get_keys_for_environment("development")
      expect(result).to have_key("DEVELOPMENT_KEY")
      expect(result).to have_key("ANOTHER_DEVELOPMENT_KEY")
    end

    it "does not return the environment keys as data" do
      expect(subject.get_keys_for_environment("development"))
        .not_to have_key("staging")
    end

    it "overrides global values with environment specific values" do
      allow(File)
        .to receive(:read)
        .and_return({
          "KEY" => "GLOBAL VALUE",
          "development" => {
            "KEY" => "env value"
          }
        }.to_yaml)

      result = subject.get_keys_for_environment("development")
      expect(result["KEY"]).to eq("env value")
    end
  end
end
