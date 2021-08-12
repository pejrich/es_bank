defmodule EsBank.Support.Command do

  defmacro __using__(_opts) do
    quote do
      import EsBank.Support.Validators
      use Vex.Struct
      use ExConstructor

      def validate(%__MODULE__{} = cmd) do
        case Vex.validate(cmd) do
          {:ok, cmd} ->
            {:ok, cmd}

          {:error, errors} ->
            {:error,
             Enum.reduce(errors, [], fn {_, key, _, msg}, acc ->
               [{key, msg} | acc]
             end)}
        end
      end
    end
  end
end
