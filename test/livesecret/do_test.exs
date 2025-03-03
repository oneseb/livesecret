defmodule LiveSecret.DoTest do
  use LiveSecret.TenantCase, async: true
  alias LiveSecret.{Secret, Do}

  test "create secret", context do
    tenant = context[:tenant]
    attrs = @valid_presecret_attrs
    changeset = Do.validate_presecret(tenant, attrs)
    assert changeset.valid?
    %Secret{id: id} = Do.insert!(tenant, attrs)
    %Secret{} = Do.get_secret!(tenant, id)
  end

  test "reject invalid secret", context do
    tenant = context[:tenant]
    attrs = @invalid_presecret_attrs
    changeset = Do.validate_presecret(tenant, attrs)
    refute changeset.valid?

    assert_raise(
      FunctionClauseError,
      fn -> Do.insert!(tenant, attrs) end
    )
  end

  test "burn secret", context do
    tenant = context[:tenant]
    secret = Do.insert!(tenant, @valid_presecret_attrs)
    %Secret{iv: nil, content: nil} = Do.burn!(secret)
  end

  test "change live state", context do
    tenant = context[:tenant]
    secret = Do.insert!(tenant, @valid_presecret_attrs)
    %Secret{live?: true} = Do.go_live!(tenant, secret.id)
    %Secret{live?: false} = Do.go_async!(tenant, secret.id)
  end
end
