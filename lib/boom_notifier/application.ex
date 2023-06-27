defmodule BoomNotifier.Application do
  use Application

  @moduledoc false

  def start(_type, _args) do
    # Telemetry attachment to make Boom work at
    # handle_event
    for lv_type <- [:live_view, :live_component] do
      :telemetry.attach(
        {lv_type, "boom-lv"},
        [:phoenix, lv_type, :handle_event, :exception],
        &BoomNotifier.Telemetry.handle_event_exception/4,
        :none
      )
    end

    children = [
      BoomNotifier.ErrorStorage,
      BoomNotifier.NotifierSenderServer
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
