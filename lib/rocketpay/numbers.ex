defmodule Rocketpay.Numbers do
  def sum_from_file(filename) do
    "#{filename}.csv"
    |> File.read()
    |> handle_file()
  end

  defp sum_numbers(result) do
    result =
      result
      |> String.split(",")
      |> Stream.map(fn number -> String.to_integer(number) end)
      |> Enum.sum()

    {:ok, %{result: result}}
  end

  defp file_is_valid(result) do
    Regex.match?(~r/^\d+(,\d+)*$/, result)
  end

  defp handle_file({:ok, result}) do
    case file_is_valid(result) do
      false -> {:error, %{message: "Invalid File Format!"}}
      true -> sum_numbers(result)
    end
  end

  defp handle_file({:error, _reason}), do: {:error, %{message: "File Not Exist!"}}
end
