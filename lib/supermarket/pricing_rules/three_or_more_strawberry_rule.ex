defmodule Supermarket.PricingRules.ThreeOrMoreStrawberryRule do
  @behaviour Supermarket.PricingRule
  alias Supermarket.Product

  # Three or more Bulk strawberry discount
  @impl Supermarket.PricingRule
  def apply(item_counts) do
    qty = Map.get(item_counts, :sr1, 0)

    if qty >= 3 do
      {:ok, %{price: original_price}} = Product.fetch(:sr1)
      new_price = Money.new(450, :GBP)
      discount_per_item = Money.sub!(original_price, new_price)
      Money.mult!(discount_per_item, qty)
    else
      Money.new(0, :GBP)
    end
  end
end
