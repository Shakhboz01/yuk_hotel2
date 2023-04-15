require "application_system_test_case"

class EndProductsTest < ApplicationSystemTestCase
  setup do
    @end_product = end_products(:one)
  end

  test "visiting the index" do
    visit end_products_url
    assert_selector "h1", text: "End products"
  end

  test "should create end product" do
    visit end_products_url
    click_on "New end product"

    fill_in "Amount left", with: @end_product.amount_left
    fill_in "Name", with: @end_product.name
    click_on "Create End product"

    assert_text "End product was successfully created"
    click_on "Back"
  end

  test "should update End product" do
    visit end_product_url(@end_product)
    click_on "Edit this end product", match: :first

    fill_in "Amount left", with: @end_product.amount_left
    fill_in "Name", with: @end_product.name
    click_on "Update End product"

    assert_text "End product was successfully updated"
    click_on "Back"
  end

  test "should destroy End product" do
    visit end_product_url(@end_product)
    click_on "Destroy this end product", match: :first

    assert_text "End product was successfully destroyed"
  end
end
