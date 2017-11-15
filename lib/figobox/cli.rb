require 'thor'

module Figobox
  class Cli < Thor
    package_name "figobox"
    map "-s" => :set

    desc "set -e development", "Apply environment variables for a figaro environment to a nanobox alias"
    method_option :figaro_environment, aliases: "-e", banner: "development", desc: "Specify figaro environment to use as a source"
    method_option :nanobox_alias, aliases: "-n", banner: "local", desc: "Specify nanobox alias to use as a target"
    method_option :dry_run, aliases: "-d", type: :boolean, desc: "Display the command rather than executing it"
    def set
      with_environments do |figaro_environment, nanobox_alias|
        parser = Figobox::ConfigParser.new
        variables = parser.get_keys_for_environment(figaro_environment)
        compiler = Figobox::CommandCompiler.new(nanobox_alias, variables)

        if options.dry_run?
          puts <<~OUTPUT
            Command to be executed:
              #{compiler.add}
          OUTPUT
        else
          system compiler.add
        end
      end
    end

    private

    def with_environments
      figaro_environment = options.figaro_environment
      figaro_environment = nil if figaro_environment == "figaro_environment"

      unless figaro_environment
        abort "You must specify a figaro environment to use as a source"
        return
      end

      nanobox_alias = options.nanobox_alias
      nanobox_alias = nil if nanobox_alias == "nanobox_alias"
      nanobox_alias ||= default_nanobox_environment(figaro_environment)

      unless nanobox_alias
        abort "Unable to automatically determine the nanobox alias to use as a target. Please use the -n option to specify one."
        return
      end

      yield(figaro_environment, nanobox_alias)
    end

    def default_nanobox_environment(figaro_environment)
      case figaro_environment.to_s.downcase
      when "development"
        "local"
      when "staging"
        "dry-run"
      when "production"
        ""
      end
    end
  end
end
