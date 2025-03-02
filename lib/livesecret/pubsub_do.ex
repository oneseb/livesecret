defmodule LiveSecret.PubSubDo do
  alias LiveSecret.Secret

  @doc """
  Subscribe to secret
  """
  def subscribe!(id) do
    :ok = Phoenix.PubSub.subscribe(LiveSecret.PubSub, Secret.topic(id))
  end

  @doc """
  Notifies PubSub topic for the secret that the provided user has been unlocked. All
  listeners should update their state for this user, and the user specified is allowed
  to receive the ciphertext.
  """
  def notify_unlocked!(id, user_id) do
    :ok = Phoenix.PubSub.broadcast(LiveSecret.PubSub, Secret.topic(id), {:unlocked, user_id})
  end
end
