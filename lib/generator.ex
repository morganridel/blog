defmodule Generator do
  require Phoenix.Template
  alias Generator.ContentReader
  alias Generator.CollectionItem
  alias Generator.PageConfig
  alias Generator.Site
  require Logger

  def init(_config \\ %{}) do
    struct!(Site, Application.get_env(:blog, :site))
  end

  def add_collection(%Site{} = site, path, opts \\ %{}) do
    default_opts = %{
      name: Path.basename(path) |> String.to_atom(),
      permalink: "/:name",
      layout: nil,
      output: true
    }

    opts = Map.merge(default_opts, opts)

    items =
      Generator.ContentReader.read_all_files(path, opts)

    new_collections =
      Map.put(site.collections, opts[:name], %{
        items: items,
        config: opts
      })

    %{site | collections: new_collections}
  end

  @spec add_pages(Generator.Site.t(), binary()) :: Generator.Site.t()
  def add_pages(%Site{} = site, path) do
    %{site | pages: site.pages ++ read_all_pages(path)}
  end

  def build(%Site{} = site) do
    File.rm_rf!(site.output_dir)

    markers = [{"Start", System.monotonic_time()}]

    case build_tailwind("./assets/css/app.css", Path.join(site.output_dir, "static/app.css")) do
      :ok -> Logger.info("✅ Assets compiled successfully.")
      {:error, _reason} -> exit({:shutdown, 1})
    end

    markers = [{"Tailwind", System.monotonic_time()} | markers]

    site.collections
    |> Enum.flat_map(fn {_key, collection} -> collection.items end)
    |> Enum.map(&build_page(&1, site))

    markers = [{"Collections", System.monotonic_time()} | markers]

    site.pages
    |> Enum.map(&build_page(&1, site))

    markers = [{"Pages", System.monotonic_time()} | markers]

    display_stats(Enum.reverse(markers))
  end

  defp display_stats(markers) do
    IO.puts("\n--- Build Breakdown ---")

    markers
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.each(fn [{_prev_label, t_start}, {label, t_end}] ->
      diff = System.convert_time_unit(t_end - t_start, :native, :millisecond)
      IO.puts("#{String.pad_trailing(label, 15)}: #{diff} ms")
    end)

    {_, first_t} = List.first(markers)
    {_, last_t} = List.last(markers)
    total = System.convert_time_unit(last_t - first_t, :native, :millisecond)

    IO.puts("-----------------------")
    IO.puts("#{String.pad_trailing("Total", 15)}: #{total} ms\n")
  end

  defp build_page({:default, {base_path, path}}, %Site{} = site) do
    output_path = Path.join([site.output_dir, Path.relative_to(path, base_path)])

    with :ok <- File.mkdir_p(Path.dirname(output_path)) do
      File.cp!(path, output_path)
    end
  end

  defp build_page(%CollectionItem{} = item, %Site{} = site) do
    IO.puts("Building page for collection item: #{item.path}")

    assigns = %{
      permalink: item.permalink,
      title: item.title,
      data: item.data
    }

    final_render = apply_layouts(item.body, item.layout, assigns, site)

    output_path = Path.join([site.output_dir, item.permalink, "index.html"])

    with :ok <- File.mkdir_p(Path.dirname(output_path)) do
      File.write!(output_path, final_render |> Phoenix.HTML.Safe.to_iodata())
    end
  end

  defp build_page({:ex, module}, %Site{} = site) do
    IO.puts("Building ex page: #{module}")
    %PageConfig{} = config = module.config(site)

    assigns = module.data(site)
    full_assigns = Map.merge(assigns, Map.from_struct(config))

    rendered_page = module.render(full_assigns)

    final_render = apply_layouts(rendered_page, config.layout, full_assigns, site)

    output_path = Path.join([site.output_dir, config.permalink, "index.html"])

    with :ok <- File.mkdir_p(Path.dirname(output_path)) do
      File.write!(output_path, final_render |> Phoenix.HTML.Safe.to_iodata())
    end
  end

  defp apply_layouts(content, nil, _assigns, _site), do: content

  defp apply_layouts(content, layout, assigns, site) do
    wrapped_content = layout.render(Map.put(assigns, :inner_content, content))

    case layout.config(site).parent do
      nil -> wrapped_content
      parent_layout -> apply_layouts(wrapped_content, parent_layout, assigns, site)
    end
  end

  def read_all_pages(path) do
    Path.wildcard(path <> "/**")
    |> Enum.filter(&File.regular?/1)
    |> Enum.map(&parse_content(&1, path))
    |> Enum.reject(&(&1 == :ignore))
  end

  defp parse_content(path, base_path) do
    ext = Path.extname(path)

    cond do
      ext in [".ex"] ->
        {module, _} = Code.compile_file(path) |> List.first()
        {:ex, module}

      ext in [".md", ".mdx"] ->
        # TODO: update so my .md page are not considered "CollectionItem"
        # decouple the read_markdown from the type production
        # have a function that make a "Page" object?
        ContentReader.read_markdown(path, %{})

      ext in [".html", ".jpg", ".png", ".jpeg", ".mp4"] ->
        {:default, {base_path, path}}

      true ->
        :ignore
    end
  end

  defp build_tailwind(input, output) do
    Logger.info("📦 Compiling Tailwind CSS via npm...")

    # TODO validate input and output to avoid injection
    command = "npx @tailwindcss/cli -i #{input} -o #{output}"

    case System.cmd("sh", ["-c", command]) do
      {_output, 0} ->
        :ok

      {output, exit_status} ->
        Logger.error("Tailwind process exited with status #{exit_status}. Output:\n#{output}")
        {:error, "Tailwind process failed."}
    end
  end
end
