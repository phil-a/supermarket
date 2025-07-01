defmodule Supermarket.Checkout do
  @moduledoc """
  The Checkout module handles the checkout process, applies pricing rules
  and calculating the total cost of items in the cart.
  """

  alias Supermarket.Product
  alias Supermarket.PricingRules.{BuyOneGetOneFreeRule, BulkFixedDiscountRule, BulkFractionalDiscountRule}

  @doc "Calculates the total cost of items in the cart."
  @spec total(list(atom)) :: Money.t()
  def total(items) do
    item_counts = Enum.frequencies(items)
    gross_total = calculate_gross_total(item_counts)
    total_discount = calculate_total_discount(item_counts)
    Money.sub!(gross_total, total_discount)
  end

  # Calculates the gross total price before discounts applied.
  defp calculate_gross_total(item_counts) do
    Enum.reduce(item_counts, Money.new(0, :GBP), fn {product_code, quantity}, acc ->
      price = Product.get_price(product_code)
      line_total = Money.mult!(price, quantity)
      Money.add!(acc, line_total)
    end)
  end

  # Calculates the total discount based on the applied pricing rules.
  defp calculate_total_discount(item_counts) do
    Enum.reduce(rules(), Money.new(0, :GBP), fn rule, acc ->
      discount = rule.__struct__.apply(rule, item_counts)
      Money.add!(acc, discount)
    end)
  end

  # all active pricing rules as structs
  defp rules do
    [
      %BuyOneGetOneFreeRule{product_code: :GR1},
      %BulkFixedDiscountRule{
        product_code: :SR1,
        min_quantity: 3,
        new_price: Money.new(450, :GBP)
      },
      %BulkFractionalDiscountRule{
        product_code: :CF1,
        min_quantity: 3,
        price_fraction: {2, 3} # numerator, denominator
      }
    ]
  end
end
