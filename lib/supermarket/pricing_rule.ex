defmodule Supermarket.PricingRule do
  @moduledoc "A behaviour for defining flexible pricing rules."

  @type t :: struct()

  @type item_counts :: %{String.t() => non_neg_integer()}

  @doc """
  Applies a pricing rule and returns the calculated discount as a Money struct.
  """
  @callback apply(t(), item_counts()) :: Money.t()
end
