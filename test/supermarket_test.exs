defmodule SupermarketTest do
  use ExUnit.Case, async: true
  doctest Supermarket

  import ExUnit.CaptureIO

  alias Supermarket.Checkout

  defp money(pounds, pence), do: Money.new(pounds * 100 + pence, :GBP)

  describe "total calculation at checkout" do
    test "Basket: GR1, SR1, GR1, GR1, CF1 -> Total: £22.45" do
      items = [:GR1, :SR1, :GR1, :GR1, :CF1]
      assert Money.compare(Checkout.total(items), money(22, 45)) == :eq
    end

    test "Basket: GR1, GR1 -> Total: £3.11 (BOGO rule)" do
      items = [:GR1, :GR1]
      assert Money.compare(Checkout.total(items), money(3, 11)) == :eq
    end

    test "Basket: SR1, SR1, GR1, SR1 -> Total: £16.61 (Bulk Strawberries rule)" do
      items = [:SR1, :SR1, :GR1, :SR1]
      assert Money.compare(Checkout.total(items), money(16, 61)) == :eq
    end

    test "Basket: GR1, CF1, SR1, CF1, CF1 -> Total: £30.57 (Bulk Coffee rule)" do
      items = [:GR1, :CF1, :SR1, :CF1, :CF1]
      assert Money.compare(Checkout.total(items), money(30, 57)) == :eq
    end

    test "handles empty baskets" do
      assert Money.compare(Checkout.total([]), money(0, 0)) == :eq
    end
  end

  describe "scan/2" do
    test "adds an item to the checkout" do
      checkout = Checkout.new()
      checkout = checkout |> Checkout.scan(:CF1)
      assert checkout.items == [:CF1]
    end

    test "adds multiple items to the checkout" do
      checkout = Checkout.new()
      checkout = checkout |> Checkout.scan(:GR1)
      checkout = checkout |> Checkout.scan(:GR1)
      assert checkout.items == [:GR1, :GR1]
    end

    test "does not add an item that does not exist" do
      checkout = Checkout.new()
      checkout = checkout |> Checkout.scan(:XYZ)
      assert checkout.items == []
    end
  end

  describe "format_receipt/1" do
    test "prints a correctly formatted receipt" do
      items = [:GR1, :SR1, :GR1, :GR1, :CF1]

      captured_output =
        capture_io(fn ->
          Checkout.format_receipt(items)
        end)

      expected_output = """
      Basket: GR1,SR1,GR1,GR1,CF1
      Total price expected: £22.45
      """
      assert captured_output == expected_output
    end
  end
end
