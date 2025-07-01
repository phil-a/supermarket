defmodule Supermarket.PricingRules.BulkFixedDiscountRule do
  @moduledoc """
  Applies a discount when a minimum quantity of an item is purchased,
  setting a new fixed price for each of those items.
  """
  @behaviour Supermarket.PricingRule

  alias Supermarket.Product
  alias Supermarket.PricingRules.BulkFixedDiscountRule

  defstruct [:product_code, :min_quantity, :new_price]

  @impl Supermarket.PricingRule
  def apply(%BulkFixedDiscountRule{product_code: code, min_quantity: min_qty, new_price: new_price}, item_counts) do
    quantity = Map.get(item_counts, code, 0)

    if quantity >= min_qty do
      original_price = Product.get_price(code)
      discount_per_item = Money.sub!(original_price, new_price)
      Money.mult!(discount_per_item, quantity)
    else
      Money.new(0, :GBP)
    end
  end
end
