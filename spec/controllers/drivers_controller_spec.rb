require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe DriversController, type: :controller do
  include SessionsHelper

  before :each do
    @driver = create(:driver)
    login_driver(@driver)
  end

  describe "GET #index" do
    context "driver logged in" do
      it 'redirects to driver#show' do
        get :index
        expect(response).to redirect_to current_driver
      end
    end

    context 'driver logged out' do
      it 'redirects to login page' do
        logout_driver
        get :index
        expect(response).to redirect_to login_url
      end
    end
  end

  describe 'GET #show' do
    context 'driver logged in' do
      it 'assigns the requested current driver to @driver' do
        get :show, params: { id: @driver }
        expect(assigns(:driver)).to eq(@driver)
      end

      it 'renders the :show template' do
        get :show, params: { id: @driver }
        expect(response).to render_template(:show)
      end

      it "redirects to current driver#show if requested other driver" do
        driver = create(:driver)
        get :show, params: { id: driver }
        expect(response).to redirect_to current_driver
      end
    end

    context 'driver logged out' do
      it 'redirects to login page' do
        logout_driver
        get :show, params: { id: @driver }
        expect(response).to redirect_to login_url
      end
    end
  end

  describe 'GET #new' do
    context "driver logged in" do
      it 'does not assigns a new driver to @driver' do
        get :new
        expect(assigns(:driver)).not_to be_a_new(Driver)
      end

      it 'redirects to driver#show' do
        get :new
        expect(response).to redirect_to current_driver
      end
    end

    context "driver logged out" do
      it 'assigns a new driver to @driver' do
        logout_driver
        get :new
        expect(assigns(:driver)).to be_a_new(Driver)
      end

      it 'renders the :new template' do
        logout_driver
        get :new
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    context 'driver logged in' do
      it "assigns the requested driver to @driver" do
        get :edit, params: { id: @driver }
        expect(assigns(:driver)).to eq @driver
      end

      it "renders the :edit template" do
        get :edit, params: { id: @driver }
        expect(response).to render_template :edit
      end

      it "redirects to current driver#show if requested other driver" do
        driver = create(:driver)
        get :edit, params: { id: driver }
        expect(response).to redirect_to current_driver
      end
    end

    context 'driver logged out' do
      it 'redirects to login page' do
        logout_driver
        get :edit, params: { id: @driver }
        expect(response).to redirect_to login_url
      end
    end
  end

  describe 'POST #create' do
    context 'driver logged in' do
      it "does not saves the new driver in the database" do
        expect{
          post :create, params: { driver: attributes_for(:driver) }
        }.not_to change(Driver, :count)
      end

      it "redirects to driver#show" do
        post :create, params: { driver: attributes_for(:driver) }
        expect(response).to redirect_to current_driver
      end
    end

    context 'driver logged out' do
      before :each do
        logout_driver
      end

      context "with valid attributes" do
        it "saves the new driver in the database" do
          expect{
            post :create, params: { driver: attributes_for(:driver) }
          }.to change(Driver, :count).by(1)
        end

        it "redirects to driver#show" do
          post :create, params: { driver: attributes_for(:driver) }
          expect(response).to redirect_to assigns(:driver)
        end
      end

      context "with invalid attributes" do
        it "does not save the new driver in the database" do
          expect{
            post :create, params: { driver: attributes_for(:invalid_driver) }
          }.not_to change(Driver, :count)
        end

        it "re-renders the :new template" do
          post :create, params: { driver: attributes_for(:invalid_driver) }
          expect(response).to render_template :new
        end
      end
    end
  end

  describe 'PATCH #update' do
    context 'driver logged in' do
      before :each do
        @driver = create(:driver, password: 'oldpassword', password_confirmation: 'oldpassword')
        login_driver(@driver)
      end

      context "with valid attributes" do
        it "locates the requested @driver" do
          patch :update, params: { id: @driver, driver: attributes_for(:driver) }
          expect(assigns(:driver)).to eq(@driver)
        end

        it "saves new password" do
          patch :update, params: { id: @driver, driver: attributes_for(:driver, password: 'newlongpassword', password_confirmation: 'newlongpassword') }
          @driver.reload
          expect(@driver.authenticate('newlongpassword')).to eq(@driver)
        end

        it "redirects to drivers#index" do
          patch :update, params: { id: @driver, driver: attributes_for(:driver) }
          expect(response).to redirect_to @driver
        end

        it "disables login with old password" do
          patch :update, params: { id: @driver, driver: attributes_for(:driver, password: 'newlongpassword', password_confirmation: 'newlongpassword') }
          @driver.reload
          expect(@driver.authenticate('oldpassword')).to eq(false)
        end
      end

      context "with invalid attributes" do
        it "does not update the driver in the database" do
          patch :update, params: { id: @driver, driver: attributes_for(:driver, password: nil, password_confirmation: nil) }
          @driver.reload
          expect(@driver.authenticate(nil)).to eq(false)
        end

        it "re-renders the :edit template" do
          patch :update, params: { id: @driver, driver: attributes_for(:invalid_driver) }
          expect(response).to render_template :edit
        end
      end
    end

    context 'driver logged out' do
      it 'redirects to login page' do
        logout_driver
        patch :update, params: { id: @driver, driver: attributes_for(:driver) }
        expect(response).to redirect_to login_url
      end
    end
  end

  describe 'GET #gopay' do
    context 'driver logged in' do
      it 'assigns the requested to driver' do
        get :gopay, params: { id: @driver }
        expect(assigns(:driver)).to eq(@driver)
      end

      it "renders the :job template" do
        get :gopay, params: { id: @driver }
        expect(response).to render_template(:gopay)
      end

      it "redirects to current driver#show if requested location other driver" do
        driver = create(:driver)
        get :gopay, params: { id: driver }
        expect(response).to redirect_to current_driver
      end
    end
  end

  describe 'GET #location' do
    context 'driver logged in' do
      it 'assigns the requested to driver' do
        get :location, params: { id: @driver }
        expect(assigns(:driver)).to eq(@driver)
      end

      it "renders the :job template" do
        get :location, params: { id: @driver }
        expect(response).to render_template(:location)
      end

      it "redirects to current driver#show if requested location other driver" do
        driver = create(:driver)
        get :location, params: { id: driver }
        expect(response).to redirect_to current_driver
      end
    end

    context 'driver logged out' do
      it 'redirects to login page' do
        logout_driver
          get :location, params: { id: @driver }
        expect(response).to redirect_to login_url
      end
    end
  end

  describe "PATCH #current_location" do
    context 'user logged in' do
      before :each do
        @driver = create(:driver, location: 'tanah abang')
        login_driver(@driver)
      end

      context "with valid attribut" do
        it "adds location to driver's location in the database" do
          patch :current_location, params: { id: @driver, driver: attributes_for(:driver), location: 'kemang' }
          @driver.reload
          expect(@driver.location). to eq('kemang')
        end

        it "redirect to the driver" do
          patch :current_location, params: { id: @driver, driver: attributes_for(:driver), location: 'kemang' }
          expect(response).to redirect_to @driver
        end
      end

      context "with invalid attribut" do
        it "does not change location to driver's location in the database" do
          patch :current_location, params: { id: @driver, driver: attributes_for(:driver), location: 'ashdgat' }
          @driver.reload
          expect(@driver.location).not_to eq('kemang')
        end

        it "re-renders :location template" do
          patch :current_location, params: { id: @driver, driver: attributes_for(:driver), location: 'ashdgat' }
          expect(response).to render_template(:location)
        end
      end
    end
  end

  describe 'GET #job history' do
    context 'driver logged in' do
      # it "assigns the requested view job's driver" do
      #   other_driver = create(:driver)
      #   order1 = build(:order, driver_id: @driver)
      #   order2 = build(:order, driver_id: @driver)
      #   order3 = build(:order, driver_id: other_driver)
      #
      #   get :job, params: { id: @driver }
      #   expect(assigns(:order)).to eq match_array([order1, order2])
      # end

      it "renders the :job template" do
        get :job, params: { id: @driver }
        expect(response).to render_template(:job)
      end

      it "redirects to current driver#show if requested location other driver" do
        driver = create(:driver)
        get :job, params: { id: driver }
        expect(response).to redirect_to current_driver
      end
    end

    context 'driver logged out' do
      it 'redirects to login page' do
        logout_driver
        get :job, params: { id: @driver }
        expect(response).to redirect_to login_url
      end
    end
  end
end
