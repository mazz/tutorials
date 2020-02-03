defmodule TutorialWeb.ProductListLive do
  use Phoenix.LiveView

  alias TutorialWeb.Router.Helpers, as: Routes
  alias TutorialWeb.ProductListLive
  alias Tutorial.Products

  def mount(%{"csrf_token" => csrf_token} = _session, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(Tutorial.PubSub, "app:#{csrf_token}")

    assigns = [
      conn: socket,
      csrf_token: csrf_token
    ]

    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    TutorialWeb.ProductView.render("products.html", assigns)
  end

  def handle_event("nav", %{"page" => page}, socket) do
    {:noreply, live_redirect(socket, to: Routes.live_path(socket, ProductListLive, page: page))}
  end

  def handle_params(%{"page" => page}, _, socket) do
    assigns = get_and_assign_page(page)
    {:noreply, assign(socket, assigns)}
  end

  def handle_params(_, _, socket) do
    assigns = get_and_assign_page(nil)
    {:noreply, assign(socket, assigns)}
  end

  def handle_info({"paginate", %{"page" => page}}, socket) do
    {:noreply, live_redirect(socket, to: Routes.live_path(socket, ProductListLive, page: page))}
  end

  def handle_info(_, socket), do: {:noreply, socket}

  def get_and_assign_page(page_number) do
    %{
      entries: entries,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    } = Products.paginate_products(page: page_number)

    [
      products: entries,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    ]
  end
end