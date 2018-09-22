require 'rails_helper'

describe Study do
  
  include FileHelpers
  include DirHelpers
  include Neo4jHelpers
  include MdrHelpers

  def sub_dir
    return "models"
  end

  def setup_mdr
    mdr_setup = MdrSetupHelpers.new
    define_setup = DefineSetupHelpers.new
  end

  before :each do
    neo4j_clear
    setup_mdr
  end

  after :each do
    #
  end

  def create_study(identifier, source=:mdr, filename="")
  	params = {name: "Whoa", identifier: "#{identifier}", source: source, filename: filename}
    item = Study.construct(params)
    expect(item.errors.count).to eq(0)
    expect(item.name).to eq("Whoa")
    expect(item.identifier).to eq("#{identifier}")
    expect(item.source).to eq(source)
    return item
  end

  def create_study_identifier_error(identifier)
  	params = {name: "Whoa", identifier: "#{identifier}", source: "mdr"}
    expect{Study.construct(params)}.to raise_error(Errors::CreateError, "Failed to create Study. Identifier is invalid.")
  end

  it "allows item to be constructed, no errors" do
  	create_study("XXX XXX")
  end

  it "allows item to be constructed, missing name" do
  	params = {identifier: "XXX XXX", source: :user}
    expect{Study.construct(params)}.to raise_error(Errors::CreateError, "Failed to create Study. Name can't be blank.")
  end

  it "allows item to be constructed, missing identifier" do
  	params = {name: "yes", source: :user}
    expect{Study.construct(params)}.to raise_error(Errors::CreateError, "Failed to create Study. Identifier can't be blank and Identifier is invalid.")
  end

  it "allows item to be constructed, missing source" do
  	params = {name: "Whoa", identifier: "XXX XXX"}
    expect{Study.construct(params)}.to raise_error(Errors::CreateError, "Failed to create Study. Source can't be blank.")
  end

  it "allows item to be constructed, filename missing with define source" do
    params = {name: "Whoa", identifier: "XXX XXX", source: :define, filename: ""}
    expect{Study.construct(params)}.to raise_error(Errors::CreateError, "Failed to create Study. Filename can't be blank.")
  end

  it "allows item to be constructed, filename with define source" do
    create_study("AAA", :define, "ddd.xml")
  end

  it "allows item to be constructed, valid identifier" do
  	create_study("THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG")
  end

  it "allows item to be constructed, valid identifier" do
  	create_study("the quick brown fox jumps over the lazy dog")
  end

  it "allows item to be constructed, valid identifier" do
  	create_study("the quick brown fox jumps over the lazy dog 0123456789")
  end

  it "allows item to be constructed, invalid identifier" do
  	create_study_identifier_error("XXX XXX £")
  end

  it "allows item to be constructed, invalid identifier" do
  	create_study_identifier_error("XXX XXX -")
  end

  it "allows item to be constructed, invalid identifier" do
  	create_study_identifier_error("XXX XXX _")
  end

  it "allows item to be constructed, invalid identifier" do
  	create_study_identifier_error("XXX XXX +")
  end

  it "initial version" do
    study = create_study("XXX")
    expect(study.study_versions.count).to eq(1)
    study_version = study.study_versions.first
    expect(study_version.identifier).to eq("XXX")
    expect(study_version.name).to eq("Whoa")    
  end

  it "history" do
    study = create_study("XXX")
    sv_1 = study.study_versions.first
    sv_1.state = Study::Version.the_released_state
    sv_1.save
    sv_2 = sv_1.edit
    expect(study.study_versions.count).to eq(2)
    result = study.history
    expect(result.count).to eq(2)
    expect(result[0].identifier).to eq("XXX")
    expect(result[1].identifier).to eq("XXX")
    expect(result[0].version).to eq(1)
    expect(result[1].version).to eq(2)
    expect(result[0].semantic_version).to eq("0.1.0")
    expect(result[1].semantic_version).to eq("0.2.0")
  end

  it "delete" do
    study = create_study("XXX")
    expect(Study.all.count).to eq(1)
    study.delete
    study = Study.find_by(identifier: "XXX")
    expect(study).to eq(nil)
    expect(Study.all.count).to eq(0)
  end
  
  it "delete, errors" do
    study = create_study("XXX")
    expect(Study.all.count).to eq(1)
    allow_any_instance_of(Study).to receive(:destroy).and_raise(StandardError.new("error"))
    expect{study.delete}.to raise_error(Errors::DestroyError)
    expect(Study.all.count).to eq(1)
  end

end
