require "spec_helper"

RSpec.describe Figobox::Cli do
  before do
    parser = double(:parser, get_keys_for_environment: { "KEY" => "val"})
    allow(Figobox::ConfigParser).to receive(:new).and_return(parser)
  end

  it "allows users to perform a dry run" do
    expect_any_instance_of(Kernel)
      .to receive(:puts)
      .with("Command to be executed:\n  nanobox evar add local KEY=val\n")

    expect_any_instance_of(Kernel)
      .not_to receive(:system)

    options = { figaro_environment: "development", dry_run: true }
    cli = Figobox::Cli.new([], options)
    cli.set
  end

  it "requires a figaro environment to be specified" do
    expect_any_instance_of(Kernel)
      .to receive(:abort)
      .with("You must specify a figaro environment to use as a source")

    options = { figaro_environment: nil }
    cli = Figobox::Cli.new([], options)
    cli.set
  end

  it "uses 'local' nanobox alias for development by default" do
    expect_any_instance_of(Kernel)
      .to receive(:system)
      .with("nanobox evar add local KEY=val")

    options = { figaro_environment: "development" }
    cli = Figobox::Cli.new([], options)
    cli.set
  end

  it "uses 'dry-run' nanobox alias for staging by default" do
    expect_any_instance_of(Kernel)
      .to receive(:system)
      .with("nanobox evar add dry-run KEY=val")

    options = { figaro_environment: "staging" }
    cli = Figobox::Cli.new([], options)
    cli.set
  end

  it "uses '' nanobox alias for production by default" do
    expect_any_instance_of(Kernel)
      .to receive(:system)
      .with("nanobox evar add  KEY=val")

    options = { figaro_environment: "production" }
    cli = Figobox::Cli.new([], options)
    cli.set
  end

  it "allows the user to set a custom nanobox alias target" do
    expect_any_instance_of(Kernel)
      .to receive(:system)
      .with("nanobox evar add my-alias KEY=val")

    options = { figaro_environment: "my_environment", nanobox_alias: "my-alias" }
    cli = Figobox::Cli.new([], options)
    cli.set
  end

  it "shows an error if the a custom figaro env is used but no alias if provided" do
    expect_any_instance_of(Kernel)
      .to receive(:abort)
      .with("Unable to automatically determine the nanobox alias to use as a target. Please use the -n option to specify one.")

    options = { figaro_environment: "custom" }
    cli = Figobox::Cli.new([], options)
    cli.set
  end
end
