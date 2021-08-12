defmodule EsBankTest do
  use EsBank.DataCase


  describe "open_account" do
    test "it works with valid inputs" do
      EsBank.open_account(%{owner: "Peter", pin: "1234"})
      |> IO.inspect()
    end
  end
end
