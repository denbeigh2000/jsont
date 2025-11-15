defmodule Jsont.NifBridge do
  # NOTE: this is kinda meh, but:
  # - this keeps the package compilable when unpatch
  # - keeping a prefix here makes it very difficult to get into a bad
  #   compilation state, both before and after patching.
  # - this will go away when we are back on a hex package, and we can jsut
  #   apply the conditional compilation patch locally.
  nif_path = "priv/_DISCORD_SPECIFIC_PREFIX_TO_BE_PATCHED_OVER_/libjsont_nif"
  @so_exists File.exists?("#{nif_path}.so")

  use Rustler,
    otp_app: :jsont,
    crate: "jsont_nif",
    skip_compilation?: @so_exists,
    load_from: {:jsont, nif_path}

  @spec encode(term(), boolean(), boolean()) :: {:ok, String.t()} | {:error, any()}
  def encode(_value, _bigint_as_string, _skip_elixir_struct),
    do: :erlang.nif_error(:nif_not_loaded)

  @spec decode(iodata(), boolean()) :: {:ok, term()} | {:error, any()}
  def decode(_value, _validate_unicode), do: :erlang.nif_error(:nif_not_loaded)
end
