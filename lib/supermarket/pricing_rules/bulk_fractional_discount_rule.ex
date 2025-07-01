defmodule Supermarket.PricingRules.BulkFractionalDiscountRule do
  @moduledoc """
  Applies a discount where the price of items drops to a fraction of the
  original if a minimum quantity is purchased.
  """
  @behaviour Supermarket.PricingRule

  alias Supermarket.Product

  defstruct [:product_code, :min_quantity, :price_fraction]

  @impl Supermarket.PricingRule
  def apply(%__MODULE__{
    product_code: code,
    min_quantity: min,
    price_fraction: {numerator, denominator}
  }, item_counts) do
    quantity = Map.get(item_counts, code, 0)

    if quantity >= min do
      price_per_item = Product.get_price(code)
      original_total = Money.mult!(price_per_item, quantity)
      new_total =
        original_total
        |> Money.mult!(numerator)
        |> Money.div!(denominator)

      Money.sub!(original_total, new_total)
    else
      Money.new(0, :GBP)
    end
  end
end
