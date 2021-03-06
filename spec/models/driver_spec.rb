require 'rails_helper'

RSpec.describe Driver, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it "has a valid factory" do
    expect(build(:driver)).to be_valid
  end

  it "has a valid with name, email, phone, password, gopay and location" do
    expect(build(:driver)).to be_valid
  end

  it "is invalid without a name" do
    driver = build(:driver, name: nil)
    driver.valid?
    expect(driver.errors[:name]).to include("can't be blank")
  end

  it "is invalid without a email" do
    driver = build(:driver, email: nil)
    driver.valid?
    expect(driver.errors[:email]).to include("can't be blank")
  end

  it "is invalid without a phone" do
    driver = build(:driver, phone: nil)
    driver.valid?
    expect(driver.errors[:phone]).to include("can't be blank")
  end

  it "is invalid with duplicate email" do
    driver1 = create(:driver, email: "nur@gmail.com")
    driver2 = build(:driver, email: "nur@gmail.com")
    driver2.valid?
    expect(driver2.errors[:email]).to include("has already been taken")
  end

  it "is invalid with an email other than given format" do
    driver = build(:driver, email: "nurgmail.com")
    driver.valid?
    expect(driver.errors[:email]).to include("format is invalid")
  end

  it "is invalid with duplicate phone number" do
    driver1 = create(:driver, phone: "085277206511")
    driver2 = build(:driver, phone: "085277206511")
    driver2.valid?
    expect(driver2.errors[:phone]).to include("has already been taken")
  end

  it 'is invalid with phone number not numeric' do
    driver = build(:driver, phone: '09-4748')
    driver.valid?
    expect(driver.errors[:phone]).to include('is not a number')
  end

  it 'is invalid with phone number length > 12' do
    driver = build(:driver, phone: '085277206511212')
    driver.valid?
    expect(driver.errors[:phone]).to include('is too long (maximum is 12 characters)')
  end

  context "on a new driver" do
    it "is invalid without password" do
      driver = build(:driver, password: nil, password_confirmation: nil)
      driver.valid?
      expect(driver.errors[:password]).to include("can't be blank")
    end

    it "is invalid with less than 8 characters password" do
      driver = build(:driver,password: "asdf", password_confirmation: "asdf")
      driver.valid?
      expect(driver.errors[:password]).to include("is too short (minimum is 8 characters)")
    end

    it "is invalid with a confirmation mismatch" do
      driver = build(:driver, password: "longpassword", password_confirmation: "newlongpassword")
      driver.valid?
      expect(driver.errors[:password_confirmation]).to include("doesn't match Password")
    end
  end

  context "on a existing driver" do
    before :each do
      @driver = create(:driver)
    end

    it "is valid with no changes" do
      expect(@driver.valid?).to eq(true)
    end

    it "is invalid with empty password" do
      @driver.password_digest = ""
      @driver.valid?
      expect(@driver.errors[:password]).to include("can't be blank")
    end

    it "is valid with a new valid password" do
      @driver.password = "newlongpassword"
      @driver.password_confirmation = "newlongpassword"
      expect(@driver.valid?).to eq(true)
    end
  end

  context "adding gopay amount" do
    it "save default go pay credit when driver created" do
      driver = create(:driver)
      expect(driver.gopay).to eq(0)
    end

    it "is invalid with non numeric gopay" do
      driver = create(:driver)
      driver.gopay = "1ooo"
      driver.valid?
      expect(driver.errors[:gopay]).to include("is not a number")
    end

    it "is invalid with gopay amount entry < 0" do
      driver = create(:driver)
      driver.gopay = -2000
      driver.valid?
      expect(driver.errors[:gopay]).to include('must be greater than or equal to 0')
    end

    it "updates gopay amount with valid topup gopay" do
      driver = create(:driver, gopay: 50000)
      driver.topup(50000)
      expect(driver.gopay).to eq(100000)
    end

    it "is invalid with non numeric topup gopay" do
      driver = create(:driver)
      driver.topup("5oooo")
      expect(driver.errors[:gopay]).to include("is not a number")
    end

    it "is invalid with topup gopay amount entry < 0" do
      driver = create(:driver)
      driver.topup(-20000)
      expect(driver.errors[:gopay]).to include('must be greater than or equal to 0')
    end
  end

  context "with location" do
    it "is valid with location" do
      driver = create(:driver)
      expect(driver.location).not_to eq(nil)
    end

    it "is invalid without locatiion" do
      driver = build(:driver, location: nil)
      driver.valid?
      expect(driver.errors[:location]).to include("can't be blank")
    end

    it 'is invalid if lat-long not found' do
      driver = build(:driver, location: "asdfxacxc")
      driver.valid?
      expect(driver.errors[:location]).to include("not found. Please check your connection or typo")
    end
  end

  context "with service_type" do
    it "is valid with service type" do
      driver = create(:driver)
      expect(driver.service_type).not_to eq(nil)
    end

    it "is invalid without service type" do
      driver = build(:driver, service_type: nil)
      driver.valid?
      expect(driver.errors[:service_type]).to include("can't be blank")
    end
  end

  describe "relations" do
    it { should have_many(:orders) }
    # it { should belong_to(:goride).class_name('Location::Goride').with_foreign_key('location_goride_id') }
  end

  describe "current location driver" do
    context 'with service type is Go Ride' do
      it "save driver_id to Location::Goride model" do
        driver = create(:driver, service_type: "Go Ride")
        expect(driver.location_goride_id).not_to eq(nil)
      end
    end

    context 'with service type is Go Car' do
      it "save driver_id to Location::Gocar model" do
        driver = create(:driver, service_type: "Go Car")
        expect(driver.location_gocar_id).not_to eq(nil)
      end
    end
  end
end
