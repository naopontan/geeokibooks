require 'test_helper'

class RentalsControllerTest < ActionController::TestCase
  setup do
    @rental = rentals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rentals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

=begin
  test "should create rental" do
    assert_difference('Rental.count') do
      post :create, rental: { book_id: @rental.book_id, state: @rental.state, user_id: @rental.user_id }
    end

    assert_redirected_to rental_path(assigns(:rental))
  end
=end

  test "should show rental" do
    get :show, id: @rental
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rental
    assert_response :success
  end

  test "should update rental" do
    put :update, id: @rental, rental: { book_id: @rental.book_id, state: @rental.state, user_id: @rental.user_id }
    assert_redirected_to rental_path(assigns(:rental))
  end

  test "should destroy rental" do
    assert_difference('Rental.count', -1) do
      delete :destroy, id: @rental
    end

    assert_redirected_to rentals_path
  end
end
