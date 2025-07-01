
defmodule Supermarket.PricingRules.BuyOneGetOneFreeRule do
  @moduledoc "Applies a 'buy one, get one free' discount for a specific product."
  @behaviour Supermarket.PricingRule

  alias Supermarket.Product

  defstruct [:product_code]

  @impl Supermarket.PricingRule
  def apply(%__MODULE__{product_code: code}, item_counts) do
    quantity = Map.get(item_counts, code, 0)

    if quantity >= 2 do
      discount_count = div(quantity, 2)
      price_per_item = Product.get_price(code)
      Money.mult!(price_per_item, discount_count)
    else
      Money.new(0, :GBP)
    end
  end
end
