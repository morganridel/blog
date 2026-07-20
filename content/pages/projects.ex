defmodule Pages.Projects do
  use Generator.Page

  def config(_site) do
    %PageConfig{
      permalink: "/projects",
      title: "Projects",
      layout: Blog.Layouts.Root
    }
  end

  def data(_site) do
    %{
      projects: [
        %{
          slug: "medianook",
          title: "Medianook",
          main_url: "https://medianook.morganridel.fr/",
          image: "/static/images/project-medianook.png",
          image_alt:
            "Screenshot of the Medianook website",
          paragraphs: [
            "Managing different accounts for tracking every kind of thing I consume is painful. Letterboxd, Goodreads, MyAnimeList…",
            "This is my attempt at managing everything in one place. It has fewer media-specific features, but offers central management and cross-media analytics as a bonus.",
            "“What have I been consuming this year?” “How generous are my ratings?” These are questions that can be answered with this project."
          ]
        },
        %{
          slug: "volunteering-at-ihl",
          title: "Volunteering at IHL",
          main_url: "https://www.internationalhouseleuven.be/",
          image: "/static/images/project-ihl-board-game-night.png",
          image_alt:
            "IHL logo",
          paragraphs: [
            ~s|I am an active member of the <a href="https://www.internationalhouseleuven.be/">International House Leuven</a> community. After enjoying the social events there, I decided to do my part.|,
            ~s|I am one of the hosts of the <a href="https://www.internationalhouseleuven.be/game-night-ihl">Board Game Night at IHL</a>. Please come by and say hi if you're around :)|
          ]
        }
      ]
    }
  end

  def render(assigns) do
    ~H"""
    <section aria-labelledby="projects-title" class="stack-xl">
      <div class="stack-sm">
        <h1 id="projects-title" class="text-3xl font-semibold text-base">Projects</h1>
        <p class="max-w-2xl text-lg text-base/80">
          This section gathers a few things that I have been working on and think are worth spotlighting.
        </p>
      </div>

      <div class="stack-xl">
        <%= for project <- @projects do %>
          <article
            id={project.slug}
            class="grid items-start gap-lg border-t-sm border-base/20 pt-xl md:grid-cols-[minmax(0,2fr)_minmax(0,3fr)]"
          >
            <a
              href={project.main_url}
              aria-label={"Visit #{project.title}"}
              class="group block overflow-hidden rounded-lg border-sm border-base/15 bg-neutral transition-shadow duration-300 hover:shadow-lg focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-accent"
            >
              <img
                src={project.image}
                alt={project.image_alt}
                width="1200"
                height="800"
                loading="lazy"
                decoding="async"
                class="aspect-3/2 w-full object-cover transition-transform duration-300 ease-out group-hover:scale-105 group-focus-visible:scale-105 motion-reduce:transition-none motion-reduce:transform-none"
              />
            </a>

            <div class="stack-sm">
              <h2 class="text-2xl font-semibold">
                <a href={project.main_url} class="text-base transition-colors hover:text-accent">
                  <%= project.title %>
                </a>
              </h2>
              <%= for paragraph <- project.paragraphs do %>
                <p class="text-base/80"><%= Phoenix.HTML.raw(paragraph) %></p>
              <% end %>
            </div>
          </article>
        <% end %>
      </div>
    </section>
    """
  end
end
