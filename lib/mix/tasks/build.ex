defmodule Mix.Tasks.Build do
  use Mix.Task
  require Logger

  @shortdoc "Builds the static blog by compiling assets and generating HTML."

  def run(_) do
    Logger.info("--- Starting Full Blog Build ---")

    case build_tailwind() do
      :ok ->
        Logger.info("✅ Assets compiled successfully.")

        build_site()

      {:error, reason} ->
        Logger.error("❌ Tailwind build failed: #{reason}")
        exit({:shutdown, 1})
    end
  end

  defp build_tailwind do
    Logger.info("📦 Compiling Tailwind CSS via npm...")

    command = "npx @tailwindcss/cli -i ./assets/css/app.css -o ./output.css"

    case System.cmd("sh", ["-c", command]) do
      {_output, 0} ->
        :ok

      {output, exit_status} ->
        Logger.error("Tailwind process exited with status #{exit_status}. Output:\n#{output}")
        {:error, "Tailwind process failed."}
    end
  end

  defp build_site do
    Logger.info("📄 Generating HTML with Elixir...")

    {:ok, _} = Application.ensure_all_started(:blog)

    Blog.Builder.run()
  end
end
