defmodule Rocketpay.Accounts.Deposit do
  alias Rocketpay.Repo
  alias Rocketpay.Accounts.Operation

  def call(params) do
    params
    |> Operation.call(:deposit)
    |> run_transactions()
  end

  defp run_transactions(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} ->
        {:error, reason}

      {:ok, %{deposit: account}} ->
        {:ok, account}
    end
  end
end
