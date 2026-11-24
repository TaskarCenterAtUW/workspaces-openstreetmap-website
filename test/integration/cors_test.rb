# frozen_string_literal: true

require "test_helper"

class CORSTest < ActionDispatch::IntegrationTest
  def test_api_routes_allow_cross_origin_requests
    options "/api/capabilities", :headers => {
      "Origin" => "http://www.example.com",
      "Access-Control-Request-Method" => "GET"
    }

    # TDEI Workspaces (config/initializers/cors.rb): any origin, with
    # credentials, so the origin is echoed back instead of "*".
    assert_response :success
    assert_equal "http://www.example.com", response.headers["Access-Control-Allow-Origin"]
    assert_equal "true", response.headers["Access-Control-Allow-Credentials"]
    assert_nil response.headers["Vary"]
    assert_nil response.media_type
    assert_equal "", response.body

    get "/api/capabilities", :headers => {
      "Origin" => "http://www.example.com",
      "Access-Control-Request-Method" => "GET"
    }

    assert_response :success
    assert_equal "http://www.example.com", response.headers["Access-Control-Allow-Origin"]
    assert_equal "true", response.headers["Access-Control-Allow-Credentials"]
    assert_equal "Origin", response.headers["Vary"]
    assert_equal "application/xml", response.media_type
  end

  def test_non_api_routes_dont_allow_cross_origin_requests
    options "/", :headers => {
      "Origin" => "http://www.example.com",
      "Access-Control-Request-Method" => "GET"
    }

    assert_response :success
    assert_nil response.headers["Access-Control-Allow-Origin"]
    assert_nil response.media_type
    assert_equal "", response.body

    get "/", :headers => {
      "Origin" => "http://www.example.com",
      "Access-Control-Request-Method" => "GET"
    }

    assert_response :success
    assert_nil response.headers["Access-Control-Allow-Origin"]
    assert_equal "text/html", response.media_type
  end
end
