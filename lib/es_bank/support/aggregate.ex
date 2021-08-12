defmodule EsBank.Support.Aggregate do
  defmacro __using__(_opts) do
    quote do
      def schema do
        __MODULE__
        |> to_string
        |> String.replace(".Aggregates.", ".Projections.")
        |> String.to_existing_atom
        |> case do
          nil -> {:error, nil}
          val -> {:ok, val}
        end
      end
    end
  end
end
