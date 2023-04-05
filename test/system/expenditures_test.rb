require "application_system_test_case"

class ExpendituresTest < ApplicationSystemTestCase
  setup do
    @expenditure = expenditures(:one)
  end

  test "visiting the index" do
    visit expenditures_url
    assert_selector "h1", text: "Expenditures"
  end

  test "should create expenditure" do
    visit expenditures_url
    click_on "New expenditure"

    fill_in "Comment", with: @expenditure.comment
    fill_in "Executor", with: @expenditure.executor_id
    fill_in "Expenditure type", with: @expenditure.expenditure_type
    fill_in "Price", with: @expenditure.price
    fill_in "Product", with: @expenditure.product_id
    fill_in "Total paid", with: @expenditure.total_paid
    fill_in "User", with: @expenditure.user_id
    click_on "Create Expenditure"

    assert_text "Expenditure was successfully created"
    click_on "Back"
  end

  test "should update Expenditure" do
    visit expenditure_url(@expenditure)
    click_on "Edit this expenditure", match: :first

    fill_in "Comment", with: @expenditure.comment
    fill_in "Executor", with: @expenditure.executor_id
    fill_in "Expenditure type", with: @expenditure.expenditure_type
    fill_in "Price", with: @expenditure.price
    fill_in "Product", with: @expenditure.product_id
    fill_in "Total paid", with: @expenditure.total_paid
    fill_in "User", with: @expenditure.user_id
    click_on "Update Expenditure"

    assert_text "Expenditure was successfully updated"
    click_on "Back"
  end

  test "should destroy Expenditure" do
    visit expenditure_url(@expenditure)
    click_on "Destroy this expenditure", match: :first

    assert_text "Expenditure was successfully destroyed"
  end
end
