defmodule Langtool.Token do
  use Joken.Config
  alias Langtool.Token

  def encode(user_id) when is_integer(user_id) do
    extra_claims = %{"user_id" => user_id}

    Token.generate_and_sign!(extra_claims, signer)
  end

  def decode(token) when is_binary(token) do
    case Token.verify_and_validate(token, signer) do
      {:ok, claims} -> claims
      _ -> {:error, "Invalid token"}
    end
  end

  defp signer, do: Joken.Signer.create("HS256", "secret")
end