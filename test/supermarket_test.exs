defmodule SupermarketTest do
  use ExUnit.Case, async: true
  doctest Supermarket

  defp money(pounds, pence), do: Money.new(pounds * 100 + pence, :GBP)

  describe "total calculation at checkout" do
    test "Basket: GR1, SR1, GR1, GR1, CF1 -> Total: £22.45" do
      items = [:gr1, :sr1, :gr1, :gr1, :cf1]
      assert Checkout.total(items) == money(22, 45)
    end

    test "Basket: GR1, GR1 -> Total: £3.11 (BOGO rule)" do
      items = [:gr1, :gr1]
      assert Checkout.total(items) == money(3, 11)
    end

    test "Basket: SR1, SR1, GR1, SR1 -> Total: £16.61 (Bulk Strawberries rule)" do
      items = [:sr1, :sr1, :gr1, :sr1]
      assert Checkout.total(items) == money(16, 61)
    end

    test "Basket: GR1, CF1, SR1, CF1, CF1 -> Total: £30.57 (Bulk Coffee rule)" do
      items = [:gr1, :cf1, :sr1, :cf1, :cf1]
      assert Checkout.total(items) == money(30, 57)
    end

    test "handles empty baskets" do
      assert Checkout.total([]) == money(0, 0)
    end
  end

  test "greets the world" do
    assert Supermarket.hello() == :world
  end
end
