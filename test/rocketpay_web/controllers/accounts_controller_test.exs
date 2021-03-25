defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.{Account, User}


  describe "deposit/2" do

    setup %{conn: conn} do
      params = %{
        name: "thiagosimon",
        password: "123456",
        nickname: "muci",
        email: "thiagosimon@email.com",
        age: 20
      }
      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)

      conn = put_req_header(conn, "authorization", "Basic YmFuYW5hOm5hbmljYTEyMw==")

      {:ok, conn: conn, account_id: account_id}
    end

    test "when all params are valid, make the deposit", %{conn: conn, account_id: account_id} do
      params = %{"value" => "20.00"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:created)


      assert %{
        "account" => %{"balance" => "20.00", "id" => _id},
        "message" =>"Ballance changed successfully"
      } = response
    end

    test "when ther are invalid params, returns an error", %{conn: conn, account_id: account_id} do
      params = %{"value" => "text"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => "Invalid deposit value!"}
      assert response == expected_response
    end

  end

end
