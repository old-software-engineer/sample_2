require 'rails_helper'

describe AuditTrail do

  include FileHelpers
  
  def sub_dir
    return "models"
  end

  before :each do
    AuditTrail.delete_all
  end

  after :each do
    AuditTrail.delete_all
  end

  it "returns a human readable label for an instance" do
    item = AuditTrail.new
    item.event = 3
    expect(item.event_to_s).to eq("Delete")
    item.event = 4
    expect(item.event_to_s).to eq("User")
  end
  
  it "returns human readbale label for an event code" do
    expect(AuditTrail.event_to_s(-5)).to eq("") # Remember: -1 to -4 work from end of array
    expect(AuditTrail.event_to_s(0)).to eq("")
    expect(AuditTrail.event_to_s(1)).to eq("Create")
    expect(AuditTrail.event_to_s(2)).to eq("Update")
    expect(AuditTrail.event_to_s(3)).to eq("Delete")
    expect(AuditTrail.event_to_s(4)).to eq("User")
    expect(AuditTrail.event_to_s(5)).to eq("")
  end
  
  it "allows a item create event to be added" do
    user = User.new
    user.email = "UserName1@example.com"
    AuditTrail.create_item_event(user, "X", "1.0.0", "Hello")
    items = AuditTrail.last(100)
    expect(items.count).to eq(1)
    expect(items[0].event).to eq(1)
    expect(items[0].identifier).to eq("X")
    expect(items[0].version).to eq("1.0.0")
    expect(items[0].description).to eq("Hello")
  end

  it "allows a item update event to be added" do
    user = User.new
    user.email = "UserName1@example.com"
    AuditTrail.update_item_event(user, "X", "1.1.0", "Something")
    items = AuditTrail.last(100)
    expect(items.count).to eq(1)
    expect(items[0].event).to eq(2)
    expect(items[0].identifier).to eq("X")
    expect(items[0].version).to eq("1.1.0")
    expect(items[0].description).to eq("Something")
  end

  it "allows a item delete event to be added" do
    user = User.new
    user.email = "UserName1@example.com"
    AuditTrail.delete_item_event(user, "X1", "1.1.1", "Well well")
    items = AuditTrail.last(100)
    expect(items.count).to eq(1)
    expect(items[0].event).to eq(3)
    expect(items[0].identifier).to eq("X1")
    expect(items[0].version).to eq("1.1.1")
    expect(items[0].description).to eq("Well well")
  end

  it "allows a user event to be added" do
    user = User.new
    user.email = "UserName1@example.com"
    AuditTrail.user_event(user, "Any old text")
    items = AuditTrail.last(100)
    expect(items.count).to eq(1)
    expect(items[0].event).to eq(4)
  end

  it "allows a generic create event to be added" do
		user = User.new
		user.email = "UserName1@example.com"
  	AuditTrail.create_event(user, "Any old text")
  	items = AuditTrail.last(100)
  	expect(items.count).to eq(1)
    expect(items[0].event).to eq(1)
  end

  it "allows a generic update event to be added" do
		user = User.new
		user.email = "UserName2@example.com"
  	AuditTrail.update_event(user, "Any old text")
  	items = AuditTrail.last(100)
  	expect(items.count).to eq(1)
    expect(items[0].event).to eq(2)
  end

  it "allows a generic delete event to be added" do
		user = User.new
		user.email = "UserName3@example.com"
  	AuditTrail.delete_event(user, "Any old text")
  	items = AuditTrail.last(100)
  	expect(items.count).to eq(1)
    expect(items[0].event).to eq(3)
	end

	it "allows filtering of events" do
		user = User.new
		user.email = "UserName1@example.com"
  	20.times do |index|
  		AuditTrail.create_item_event(user, "ITEM", "V1", "Any old text#{index}")
  		AuditTrail.update_item_event(user, "ITEM", "V1", "Any old text#{index}")
  		AuditTrail.delete_item_event(user, "ITEM", "V1", "Any old text#{index}")
  	end
		user.email = "UserName2@example.com"
  	20.times do |index|
  		AuditTrail.create_item_event(user, "ITEM", "V1", "Any old text#{index}")
  		AuditTrail.update_item_event(user, "ITEM", "V1", "Any old text#{index}")
  		AuditTrail.delete_item_event(user, "ITEM", "V1", "Any old text#{index}")
  	end
  	user.email = "UserName3@example.com"
  	20.times do |index|
  		AuditTrail.create_item_event(user, "ITEM", "V1", "Any old text#{index}")
  		AuditTrail.update_item_event(user, "ITEM", "V1", "Any old text#{index}")
  		AuditTrail.delete_item_event(user, "ITEM", "V1", "Any old text#{index}")
  	end
  	user.email = "UserName1@example.com"
    10.times do |index|
      AuditTrail.create_event(user, "Any old text#{index}")
      AuditTrail.update_event(user, "Any old text#{index}")
      AuditTrail.delete_event(user, "Any old text#{index}")
    end
    user.email = "UserName2@example.com"
    10.times do |index|
      AuditTrail.create_event(user, "Any old text#{index}")
      AuditTrail.update_event(user, "Any old text#{index}")
      AuditTrail.delete_event(user, "Any old text#{index}")
    end
    user.email = "UserName3@example.com"
    10.times do |index|
      AuditTrail.create_event(user, "Any old text#{index}")
      AuditTrail.update_event(user, "Any old text#{index}")
      AuditTrail.delete_event(user, "Any old text#{index}")
    end
    user.email = "UserName4@example.com"
    10.times do |index|
      AuditTrail.user_event(user, "Any old text#{index}")
    end
    items = AuditTrail.last(500)
  	expect(items.count).to eq(280)
  	items = AuditTrail.where({:user => "UserName1@example.com"})
    expect(items.count).to eq(90)
  	items = AuditTrail.where({:identifier => "ITEM"})
    expect(items.count).to eq(180)
  	items = AuditTrail.where({:event => 2})
    expect(items.count).to eq(90)
    items = AuditTrail.where({:event => 4})
    expect(items.count).to eq(10)
  	items = AuditTrail.where({:user => "UserName1@example.com", :identifier => "ITEM", :event => 2})
    expect(items.count).to eq(20)
    items = AuditTrail.where({:user => "UserName4@example.com"})
    expect(items.count).to eq(10)
	end

  it "allows CSV export of the audit trail" do
    user = User.new
    user.email = "UserName1@example.com"
    20.times do |index|
      AuditTrail.create_item_event(user, "ITEM", "V1", "Any old text#{index}")
      AuditTrail.update_item_event(user, "ITEM", "V1", "Any old text#{index}")
      AuditTrail.delete_item_event(user, "ITEM", "V1", "Any old text#{index}")
    end
    user.email = "UserName2@example.com"
    20.times do |index|
      AuditTrail.create_item_event(user, "ITEM", "V1", "Any old text#{index}")
      AuditTrail.update_item_event(user, "ITEM", "V1", "Any old text#{index}")
      AuditTrail.delete_item_event(user, "ITEM", "V1", "Any old text#{index}")
    end
    user.email = "UserName3@example.com"
    20.times do |index|
      AuditTrail.create_item_event(user, "ITEM", "V1", "Any old text#{index}")
      AuditTrail.update_item_event(user, "ITEM", "V1", "Any old text#{index}")
      AuditTrail.delete_item_event(user, "ITEM", "V1", "Any old text#{index}")
    end
    user.email = "UserName1@example.com"
    10.times do |index|
      AuditTrail.create_event(user, "Any old text#{index}")
      AuditTrail.update_event(user, "Any old text#{index}")
      AuditTrail.delete_event(user, "Any old text#{index}")
    end
    user.email = "UserName2@example.com"
    10.times do |index|
      AuditTrail.create_event(user, "Any old text#{index}")
      AuditTrail.update_event(user, "Any old text#{index}")
      AuditTrail.delete_event(user, "Any old text#{index}")
    end
    user.email = "UserName3@example.com"
    10.times do |index|
      AuditTrail.create_event(user, "Any old text#{index}")
      AuditTrail.update_event(user, "Any old text#{index}")
      AuditTrail.delete_event(user, "Any old text#{index}")
    end
    user.email = "UserName4@example.com"
    10.times do |index|
      AuditTrail.user_event(user, "Any old text#{index}")
    end
    items = AuditTrail.all
    csv = AuditTrail.to_csv
  #write_text_file(csv, sub_dir, "audit_export.csv")
    keys = ["datetime", "user", "identifier", "version", "event", "details"]
    results = CSV.read(test_file_path(sub_dir, 'audit_export.csv')).map {|a| Hash[ keys.zip(a) ]}
    items.each_with_index do |item, index|
      expect(item.date_time).to be_within(2.seconds).of(Time.now)
      expect(item.user).to eq(results[index + 1]["user"])
      expect(item.identifier).to eq(results[index + 1]["identifier"])
      expect(item.version).to eq(results[index + 1]["version"])
      expect(item.event_to_s).to eq(results[index + 1]["event"])
      expect(item.description).to eq(results[index + 1]["details"])
    end

  end

end
