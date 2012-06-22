require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
  setup do
    @contact = contacts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contacts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create contact" do
    assert_difference('Contact.count') do
      post :create, contact: { address: @contact.address, category: @contact.category, cell: @contact.cell, company: @contact.company, country: @contact.country, fax: @contact.fax, first_name: @contact.first_name, infos: @contact.infos, is_active: @contact.is_active, is_ceres_member: @contact.is_ceres_member, last_name: @contact.last_name, position: @contact.position, postal_code: @contact.postal_code, telphone: @contact.telphone }
    end

    assert_redirected_to contact_path(assigns(:contact))
  end

  test "should show contact" do
    get :show, id: @contact
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @contact
    assert_response :success
  end

  test "should update contact" do
    put :update, id: @contact, contact: { address: @contact.address, category: @contact.category, cell: @contact.cell, company: @contact.company, country: @contact.country, fax: @contact.fax, first_name: @contact.first_name, infos: @contact.infos, is_active: @contact.is_active, is_ceres_member: @contact.is_ceres_member, last_name: @contact.last_name, position: @contact.position, postal_code: @contact.postal_code, telphone: @contact.telphone }
    assert_redirected_to contact_path(assigns(:contact))
  end

  test "should destroy contact" do
    assert_difference('Contact.count', -1) do
      delete :destroy, id: @contact
    end

    assert_redirected_to contacts_path
  end
end
