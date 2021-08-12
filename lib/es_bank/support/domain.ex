defmodule EsBank.Support.Domain do
  defmacro __using__(_opts) do
    quote do

      @default_router_config [application: EsBank.App, consistency: :strong]

      def handle_command(args, command, config \\ []) do
        args
        |> command.new
        |> command.validate
        |> dispatch_command(config)
      end

      def handle_command_and_get(args, command, uuid, config \\ []) do
        args
        |> handle_command(command, config)
        |> get(command, uuid)
      end

      def get(:ok, command, uuid) do
        command
        |> schema_for_command
        |> case do
          {:ok, schema} -> EsBank.Repo.get(schema, uuid)
          err -> err
        end
      end

      def get(err, _, _), do: err

      def get(schema, uuid), do: EsBank.Repo.get(schema, uuid)

      def dispatch_command(command, config \\ [])
      def dispatch_command({:error, _} = error, _config), do: error

      def dispatch_command({:ok, command}, config), do: dispatch_command(command, config)

      def dispatch_command(%_{} = command, config) do
        EsBank.Router.dispatch(command, Keyword.merge(@default_router_config, config))
      end

      def schema_for_command(command) do
        with {:ok, agg} <- EsBank.Router.aggregate_for_command(command),
             {:ok, schema} <- agg.schema do
          {:ok, schema}
        else
          _ -> {:error, :schema_not_found}
        end
      end
    end
  end
end
