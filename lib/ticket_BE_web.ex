defmodule Ticket_BEWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, components, channels, and so on.

  This can be used in your application as:

      use Ticket_BEWeb, :controller
      use Ticket_BEWeb, :html

  The definitions below will be executed for every controller,
  component, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define additional modules and import
  those modules here.
  """

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def router do
    quote do
      use Phoenix.Router, helpers: false

      # Import common connection and controller functions to use in pipelines
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def controller do
    quote do
      use Phoenix.Controller,
        formats: [:html, :json],
        layouts: [html: Ticket_BEWeb.Layouts]

      import Plug.Conn
      import Ticket_BEWeb.Gettext

      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: Ticket_BEWeb.Endpoint,
        router: Ticket_BEWeb.Router,
        statics: Ticket_BEWeb.static_paths()
    end
  end

  # def json do
  #   quote do
  #     use Phoenix.View, namespace: Ticket_BEWeb, root: "lib/ticket_BE_web/controller"
  #     # Include shared imports and aliases
  #     import Phoenix.Controller
  #     import Phoenix.View
  #   end
  # end

  @doc """
  When used, dispatch to the appropriate controller/live_view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
