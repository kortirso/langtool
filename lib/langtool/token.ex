defmodule Langtool.Token do
  use Joken.Config
  alias Langtool.Token

  def encode(user_id) when is_integer(user_id) do
    signer = Joken.Signer.create("HS256", "secret")
    extra_claims = %{"user_id" => user_id}

    Token.generate_and_sign!(extra_claims, signer)
  end

  def decode(token) when is_binary(token) do
    signer = Joken.Signer.create("HS256", "secret")
    {:ok, claims} = Token.verify_and_validate(token, signer)

    claims
  end
end