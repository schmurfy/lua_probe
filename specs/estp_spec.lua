
local estp = require("../protocols/estp")

context("ESTP", function()
  before(function()
    old_time = os.time
    os.time = function()
      return 1339680040
    end
  end)
  
  after(function()
    os.time = old_time
  end)
  
  test("can generate correct string for counter", function()
    assert_equal(
        estp.build_request("localhost", "sys", "", "cpu", 45.5688, 10, "counter"),
        "ESTP:localhost:sys::cpu: 2012-06-14T13:20:40 10 45.568800:c"
        )
  end)
  
  test("can generate correct string for gauge", function()
    assert_equal(
        estp.build_request("localhost", "sys", "", "cpu", 45.5688, 10),
        "ESTP:localhost:sys::cpu: 2012-06-14T13:20:40 10 45.568800"
        )
  end)
  
end)
