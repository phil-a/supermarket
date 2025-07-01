defmodule Supermarket.PricingRules.BogoGreenTeaRule do
  @behaviour Supermarket.PricingRule
  alias Supermarket.Product

  # Buy one get one free rule for Green Tea
  @impl Supermarket.PricingRule
  def apply(item_counts) do
    qty = Map.get(item_counts, :gr1, 0)
    free_items = div(qty, 2)
    {:ok, %{price: price}} = Product.fetch(:gr1)
    Money.mult!(price, free_items)
  end
end
