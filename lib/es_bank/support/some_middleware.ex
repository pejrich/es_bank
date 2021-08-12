defmodule EsBank.Support.SomeMiddleware do
  @behaviour Commanded.Middleware

  alias Commanded.Middleware.Pipeline
  import Pipeline

  # %Commanded.Middleware.Pipeline{
  #   application: nil,
  #   assigns: %{},
  #   causation_id: nil,
  #   command: nil,
  #   command_uuid: nil,
  #   consistency: nil,
  #   correlation_id: nil,
  #   halted: false,
  #   identity: nil,
  #   identity_prefix: nil,
  #   metadata: nil,
  #   response: nil
  # }


  def before_dispatch(%Pipeline{} = pipeline) do
    pipeline
  end

  def after_dispatch(%Pipeline{} = pipeline) do
    pipeline
  end

  def after_failure(%Pipeline{} = pipeline) do
    pipeline
  end
end
