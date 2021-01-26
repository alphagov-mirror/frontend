require "test_helper"

class LocalTransactionServicesTest < ActiveSupport::TestCase
  context ".unavailable?" do
    should "include Scotland for service 461" do
      assert true, LocalTransactionServices.instance.unavailable?(461, "Scotland")
    end

    should "not include Northern Ireland for service 461" do
      assert_not LocalTransactionServices.instance.unavailable?(461, "Northern Ireland")
    end
  end

  context ".content" do
    should "return a string with the given country and local authority name in" do
      assert_equal "This service is unavailable in Dundee, Scotland", LocalTransactionServices.instance.content(461, "Scotland", "Dundee")
    end
  end
end
