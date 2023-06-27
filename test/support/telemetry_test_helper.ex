defmodule Support.TelemetryTestHelpers do
  @moduledoc false

  import ExUnit.Callbacks, only: [on_exit: 1]

  def attach_telemetry() do
    unique_name = :"PID#{System.unique_integer()}"
    Process.register(self(), unique_name)

    for lv_type <- [:live_view, :live_component] do
      :telemetry.attach(
        {lv_type, "boom-lv-test"},
        [:phoenix, lv_type, :handle_event, :exception],
        fn event, measurements, metadata, :none ->
          send(unique_name, {:event, event, measurements, metadata})
        end,
        :none
      )
    end

    on_exit(fn ->
      for suffix <- [:start, :stop] do
        :telemetry.detach({suffix, unique_name})
      end
    end)
  end
end
