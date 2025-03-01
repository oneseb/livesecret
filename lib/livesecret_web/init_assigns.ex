defmodule LiveSecretWeb.InitAssigns do
  alias LiveSecret.Do
  alias Phoenix.Component

  def on_mount(:default, _params, _session, socket) do
    # @todo: get domain from http header as tenant id
    {:cont,
     socket
     |> Component.assign_new(:tenant, fn -> Do.open_tenant("default") end)}
  end
end
