defmodule Blog.Layouts.Root do
  use Generator.Layout

  def config(_site) do
    %LayoutConfig{}
  end

  def render(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Morgan Ridel - {@title}</title>
      <link rel="stylesheet" href="/static/app.css">
    </head>
    <body class='bg-primary text-base box-md min-h-screen flex flex-col'>
      <div class="stack-lg flex-1">
          <header class="flex justify-between">
          <div class="cluster-md">
            <div><a href="/" class="text-2xl text-accent">Morgan Ridel</a></div>
            <!-- Extract the animated border in a class? -->
            <div class="relative block after:absolute after:left-1/2 after:bottom-0 after:h-(--border-width-md) after:w-full
                        after:-translate-x-1/2 after:translate-y-(--border-width-md) after:scale-x-0 after:origin-center
                    after:bg-accent after:transition-transform hover:after:scale-x-100">
                    <a href="/" class="text-xl text-base">Blog</a>
                    </div>
            <div class="relative block after:absolute after:left-1/2 after:bottom-0 after:h-(--border-width-md) after:w-full
                        after:-translate-x-1/2 after:translate-y-(--border-width-md) after:scale-x-0 after:origin-center
                    after:bg-accent after:transition-transform hover:after:scale-x-100">
                    <a href="/about" class="text-xl text-base">About</a>
            </div>
          </div>
          <div class="cluster-md">
            <a target="_blank" rel="noopener nofollow" aria-label="Link to https://twitter.com/morganridel" href="https://twitter.com/morganridel">
              <svg width="16" height="13" viewBox="0 0 16 13" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M14.0658 2.34438C14.7013 1.96349 15.1892 1.3604 15.419 0.641811C14.8244 0.994439 14.1658 1.25056 13.4648 1.3886C12.9034 0.7905 12.1036 0.416748 11.2185 0.416748C9.51888 0.416748 8.14096 1.79461 8.14096 3.49411C8.14096 3.7353 8.16822 3.97019 8.22068 4.19542C5.66301 4.06708 3.39543 2.84191 1.8776 0.980064C1.6127 1.43458 1.46094 1.96322 1.46094 2.52719C1.46094 3.59485 2.00428 4.5368 2.83003 5.08865C2.32553 5.07268 1.85104 4.93425 1.43608 4.70376C1.43586 4.71659 1.43586 4.72949 1.43586 4.74244C1.43586 6.23349 2.49666 7.47732 3.90448 7.75999C3.64622 7.83033 3.37436 7.86792 3.09366 7.86792C2.89537 7.86792 2.70257 7.84866 2.51471 7.81272C2.90629 9.03537 4.0428 9.92509 5.38945 9.94994C4.33623 10.7753 3.00928 11.2673 1.56749 11.2673C1.31911 11.2673 1.07413 11.2528 0.833374 11.2243C2.19527 12.0975 3.81291 12.6069 5.55081 12.6069C11.2113 12.6069 14.3067 7.91763 14.3067 3.85096C14.3067 3.71753 14.3037 3.5848 14.2978 3.45285C14.899 3.01896 15.4208 2.47694 15.8334 1.8598C15.2815 2.10456 14.6884 2.26998 14.0658 2.34438Z" fill="#73737D"></path></svg>
            </a>
            <a target="_blank" rel="noopener nofollow" data-a11y="false" aria-label="Link to https://github.com/morganridel" href="https://github.com/morganridel" class="css-1vza8sx e1dx16qw0">
            <svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M7 0C3.1325 0 0 3.21173 0 7.17706C0 10.3529 2.00375 13.0353 4.78625 13.9863C5.13625 14.0491 5.2675 13.8338 5.2675 13.6454C5.2675 13.4749 5.25875 12.9097 5.25875 12.3087C3.5 12.6406 3.045 11.8691 2.905 11.4653C2.82625 11.259 2.485 10.622 2.1875 10.4516C1.9425 10.317 1.5925 9.98508 2.17875 9.97611C2.73 9.96714 3.12375 10.4964 3.255 10.7118C3.885 11.7973 4.89125 11.4923 5.29375 11.3039C5.355 10.8374 5.53875 10.5234 5.74 10.3439C4.1825 10.1645 2.555 9.54549 2.555 6.80026C2.555 6.01976 2.82625 5.37382 3.2725 4.87143C3.2025 4.692 2.9575 3.95635 3.3425 2.96951C3.3425 2.96951 3.92875 2.78111 5.2675 3.70516C5.8275 3.54367 6.4225 3.46293 7.0175 3.46293C7.6125 3.46293 8.2075 3.54367 8.7675 3.70516C10.1063 2.77214 10.6925 2.96951 10.6925 2.96951C11.0775 3.95635 10.8325 4.692 10.7625 4.87143C11.2087 5.37382 11.48 6.01079 11.48 6.80026C11.48 9.55446 9.84375 10.1645 8.28625 10.3439C8.54 10.5682 8.75875 10.9988 8.75875 11.6717C8.75875 12.6316 8.75 13.4032 8.75 13.6454C8.75 13.8338 8.88125 14.0581 9.23125 13.9863C11.9963 13.0353 14 10.3439 14 7.17706C14 3.21173 10.8675 0 7 0Z" fill="#73737D"></path></svg>
            </a>
            <a target="_blank" rel="noopener nofollow" data-a11y="false" aria-label="Link to https://www.linkedin.com/in/morgan-ridel-017a9ab6/" href="https://www.linkedin.com/in/morgan-ridel-017a9ab6/" class="css-1vza8sx e1dx16qw0">
            <svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M3.59615 13.125H0.871552V4.36523H3.59615V13.125ZM2.24847 3.16406C1.81878 3.16406 1.44769 3.00781 1.13519 2.69531C0.822692 2.38281 0.666443 2.01171 0.666443 1.58203C0.666443 1.15234 0.822692 0.781248 1.13519 0.468749C1.44769 0.156249 1.81878 0 2.24847 0C2.67816 0 3.04925 0.156249 3.36175 0.468749C3.67425 0.781248 3.8305 1.15234 3.8305 1.58203C3.8305 2.01171 3.67425 2.38281 3.36175 2.69531C3.04925 3.00781 2.67816 3.16406 2.24847 3.16406ZM13.7915 13.125H11.0669V8.84765C11.0669 8.14452 11.0083 7.63671 10.8911 7.32421C10.6763 6.79687 10.2563 6.5332 9.63134 6.5332C9.00634 6.5332 8.56689 6.76757 8.31298 7.23632C8.11767 7.58788 8.02001 8.10546 8.02001 8.78905V13.125H5.32471V4.36523H7.93212V5.5664H7.96142C8.15673 5.17578 8.46923 4.85351 8.89892 4.59961C9.36767 4.28711 9.91454 4.13086 10.5395 4.13086C11.8091 4.13086 12.6977 4.53125 13.2055 5.33203C13.5962 5.97656 13.7915 6.97265 13.7915 8.3203V13.125Z" fill="#73737D"></path>
            </svg>
            </a>
          </div>

          </header>
          <div class='center'>
              <main class="stack-lg">
                {include(@inner_content)}
              </main>
          </div>

          <footer class='center center-intrinsic box-md border-base/50 border-t-sm mt-auto'>
            <p class="text-base/50">Website generated with <a href="https://github.com/morganridel/blog">my own Elixir SSG</a></p>
          </footer>
      </div>
    </body>

    <script type="module">
    import Stack from '/static/components/compositions/Stack.js'
    </script>
    </html>
    """
  end
end
