require "application_system_test_case"

class ProductPricesTest < ApplicationSystemTestCase
  setup do
    @product_price = product_prices(:one)
  end

  test "visiting the index" do
    visit product_prices_url
    assert_selector "h1", text: "Product prices"
  end

  test "should create product price" do
    visit product_prices_url
    click_on "New product price"

    fill_in "Price", with: @product_price.price
    fill_in "Product", with: @product_price.product_id
    click_on "Create Product price"

    assert_text "Product price was successfully created"
    click_on "Back"
  end

  test "should update Product price" do
    visit product_price_url(@product_price)
    click_on "Edit this product price", match: :first

    fill_in "Price", with: @product_price.price
    fill_in "Product", with: @product_price.product_id
    click_on "Update Product price"

    assert_text "Product price was successfully updated"
    click_on "Back"
  end

  test "should destroy Product price" do
    visit product_price_url(@product_price)
    click_on "Destroy this product price", match: :first

    assert_text "Product price was successfully destroyed"
  end
end
