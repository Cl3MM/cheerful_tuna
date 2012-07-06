require 'test_helper'

class MembersControllerTest < ActionController::TestCase
  setup do
    @member = members(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:members)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create member" do
    assert_difference('Member.count') do
      post :create, member: { activity: @member.activity, address: @member.address, billing_address: @member.billing_address, billing_city: @member.billing_city, billing_country: @member.billing_country, billing_postal_code: @member.billing_postal_code, category: @member.category, city: @member.city, company: @member.company, country: @member.country, postal_code: @member.postal_code, vat_number: @member.vat_number }
    end

    assert_redirected_to member_path(assigns(:member))
  end

  test "should show member" do
    get :show, id: @member
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @member
    assert_response :success
  end

  test "should update member" do
    put :update, id: @member, member: { activity: @member.activity, address: @member.address, billing_address: @member.billing_address, billing_city: @member.billing_city, billing_country: @member.billing_country, billing_postal_code: @member.billing_postal_code, category: @member.category, city: @member.city, company: @member.company, country: @member.country, postal_code: @member.postal_code, vat_number: @member.vat_number }
    assert_redirected_to member_path(assigns(:member))
  end

  test "should destroy member" do
    assert_difference('Member.count', -1) do
      delete :destroy, id: @member
    end

    assert_redirected_to members_path
  end
end
