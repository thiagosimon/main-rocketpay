defmodule Rocketpay.Accounts.Withdraw do
  alias Rocketpay.Repo
  alias Rocketpay.Accounts.Operation

  def call(params) do
    params
    |> Operation.call(:withdraw)
    |> run_transactions()
  end

  defp run_transactions(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} ->
        {:error, reason}

      {:ok, %{withdraw: account}} ->
        {:ok, account}
    end
  end
end
