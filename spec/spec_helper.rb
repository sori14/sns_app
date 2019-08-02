require 'support/helpers/request_helpers'
require 'support/helpers/system_helpers'


RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # Requestテストのhelperメソッドの有効化
  config.include(RequestHelpers, :type => :request)
  # Systemテストのhelperメソッドの有効化
  config.include(SystemHelpers, :type => :system)

  config.shared_context_metadata_behavior = :apply_to_host_groups

  # aggregate_failuresを全てのテストで使用できるようにする。
  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true unless meta.key?(:aggregate_failures)
  end
end
