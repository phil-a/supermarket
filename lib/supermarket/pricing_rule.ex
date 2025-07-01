defmodule Supermarket.PricingRule do
  @moduledoc "A behaviour for defining flexible pricing rules."

  @doc """
  Calculates a discount based on a map of item counts.

  This callback should be implemented by any module that acts as a pricing rule.
  It receives a map of item codes to their quantities and should return the
  total discount for that rule as a `Money.t()` struct.
  """
  @callback apply(map()) :: Money.t()
end
