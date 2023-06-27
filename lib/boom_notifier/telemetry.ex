defmodule BoomNotifier.Telemetry do
  @moduledoc false

  def handle_event_exception(
        [:phoenix, lv_type, :handle_event, :exception],
        _,
        _metadata,
        _config
      )
      when lv_type in [:live_view, :live_component] do
    IO.puts("boom handle_event_exception telemetry")

    # BoomNotifier.notify_error(conn, error)
  end
end
