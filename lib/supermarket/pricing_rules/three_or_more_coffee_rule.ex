defmodule Supermarket.PricingRules.ThreeOrMoreCoffeeRule do
  @behaviour Supermarket.PricingRule
  alias Supermarket.Product

  # Three or more bulk coffee discount
  @impl Supermarket.PricingRule
  def apply(item_counts) do
    qty = Map.get(item_counts, :cf1, 0)

    if qty >= 3 do
      {:ok, %{price: original_price}} = Product.fetch(:cf1)
      total_coffee_price = Money.mult!(original_price, qty)
      total_discount = Money.div!(total_coffee_price, 3) # keep precision to avoid rounding errors
      Money.round(total_discount)
    else
      Money.new(0, :GBP)
    end
  end
end
