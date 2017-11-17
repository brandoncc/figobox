require "bundler/setup"
require "figobox"

class ExecutionAbortedEarlyError < StandardError; end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect

    config.before(:each) do |ex|
      unless ex.metadata[:allow_abort]
        allow_any_instance_of(Kernel)
          .to receive(:abort) do |_, message|
            raise ExecutionAbortedEarlyError, message
          end
      end
    end
  end
end
