defmodule Supermarket.Cldr do
  @moduledoc """
  The CLDR backend module for this application.

  It configures the locales we support and the data providers
  (like Numbers and Currencies) that we need.
  """
  use Cldr,
    locales: ["en-GB", "fr", "es"],
    default_locale: "en-GB",

    providers: [Cldr.Number, Cldr.Currency]
end
