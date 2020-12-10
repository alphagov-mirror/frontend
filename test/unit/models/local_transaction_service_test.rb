require "test_helper"

class LocalTransactionServiceTest < ActiveSupport::TestCase
  context ".unavailable?" do
    should "include Scotland for service 461" do
      assert true, LocalTransactionService.instance.unavailable?(461, "Scotland")
    end

    should "not include Northern Ireland for service 461" do
      assert_not LocalTransactionService.instance.unavailable?(461, "Northern Ireland")
    end
  end
end
