require 'rails_helper'

describe Study::Variable do
  
  include FileHelpers
  include Neo4jHelpers
  include StudyHelpers
  include MdrHelpers
  include UriHelpers
  
  def sub_dir
    return "models/study/variable"
  end

  before :each do
    neo4j_clear
    uri = Uri.new({uri: "http://www.assero.co.uk/a"})
  	params = {uri: uri.to_s, name: "Whoa", identifier: "XXX", owner: "CDISC", semantic_version: "1.2.3"}
    @ref = Mdr::Variable.construct(params)
  end

  after :each do
    #
  end

  it "create variable" do
    params = {short_name: "XSTEST", name: "Test name", version_uuid: "1234-5678", ordinal: 3, user: false, used: true, 
      core: :required, previous_used: true, role: "Role"}
    result = Study::Variable.construct(params, @ref)
    expect(result.errors.count).to eq(0)
  end

  it "cannot create, missing short name" do
    params = {name: "Test name", ordinal: 3, user: false, version_uuid: "1234-5678", used: true, core: :required, previous_used: true, role: "Role"}
    expect{Study::Variable.construct(params, @ref)}.to raise_error(Errors::CreateError, "Failed to create Study::Variable. Short name can't be blank.")
  end

  it "cannot create, missing name" do
    params = {short_name: "XSTEST", ordinal: 3, user: false, version_uuid: "1234-5678", used: true, core: :required, previous_used: true, role: "Role"}
    expect{Study::Variable.construct(params, @ref)}.to raise_error(Errors::CreateError, "Failed to create Study::Variable. Name can't be blank.")
  end

  it "cannot create, missing ordinal" do
    params = {short_name: "XSTEST", name: "Test name", user: false, version_uuid: "1234-5678", used: true, core: :required, previous_used: true, role: "Role"}
    expect{Study::Variable.construct(params, @ref)}.to raise_error(Errors::CreateError, "Failed to create Study::Variable. Ordinal can't be blank.")
  end

  it "cannot create, missing core" do
    params = {short_name: "XSTEST", name: "Test name", user: false, version_uuid: "1234-5678", used: true, ordinal: 7, previous_used: true, role: "Role"}
    expect{Study::Variable.construct(params, @ref)}.to raise_error(Errors::CreateError, "Failed to create Study::Variable. Core can't be blank.")
  end

  it "cannot create, missing user and used" do
    params = {short_name: "XSTEST", name: "Test name", ordinal: 3, version_uuid: "1234-5678", core: :required, previous_used: true, role: "Role"}
    expect{Study::Variable.construct(params, @ref)}.to raise_error(Errors::CreateError, 
      "Failed to create Study::Variable. Used is not included in the list and User is not included in the list.") 
  end

  it "cannot create, missing previous_used" do
    params = {short_name: "XSTEST", name: "Test name", ordinal: 3, version_uuid: "1234-5678", user: false, used: true, core: :required, role: "Role"}
    expect{Study::Variable.construct(params, @ref)}.to raise_error(Errors::CreateError, 
      "Failed to create Study::Variable. Previous used is not included in the list.") 
  end

  it "cannot create, missing role" do
    params = {short_name: "XSTEST", name: "Test name", ordinal: 3, version_uuid: "1234-5678", user: false, used: true, core: :required, previous_used: true}
    expect{Study::Variable.construct(params, @ref)}.to raise_error(Errors::CreateError, 
      "Failed to create Study::Variable. Role can't be blank.") 
  end

  it 'handles create errors' do
    params = {short_name: "XSTEST", name: "Test name", ordinal: 3, version_uuid: "1234-5678", user: false, used: true, core: :required, previous_used: true}
  	response = Study::Variable.new
  	response.errors.add "ERROR" # Dummy error, just needs to be not empty.
  	expect(Study::Variable).to receive(:create).and_return(response)
  	expect{Study::Variable.construct(params, @ref)}.to raise_error(Errors::CreateError, 
      "Failed to create Study::Variable. Error is invalid.") 
  end

  it "returns value level metadata"

  it "returns the origin, assigned" do
  	params = {short_name: "VSABC", name: "Test name", ordinal: 3, version_uuid: "1234-5678", user: false, used: true, core: :required, previous_used: true, role: "XXX"}
    result = Study::Variable.construct(params, @ref)
    expect(result.errors.count).to eq(0)
    expect(result.origin).to eq("Assigned")
  end

  it "returns the origin, derived" do
  	params = {short_name: "VSABC", name: "Test name", ordinal: 3, version_uuid: "1234-5678", user: false, used: true, core: :required, previous_used: true, role: "XXX"}
    result = Study::Variable.construct(params, @ref)
    expect(result.errors.count).to eq(0)
    params = {name: "derivation", description: "Whateves", formal_expression: "FE"}
    derivation = Mdr::Derivation.construct(params)
    result.derivation_used = derivation
    expect(result.origin).to eq("Derived")
  end

  it "returns the origin, derived" do
  	params = {short_name: "VSABC", name: "Test name", ordinal: 3, version_uuid: "1234-5678", user: false, used: true, core: :required, previous_used: true, role: "XXX"}
    result = Study::Variable.construct(params, @ref)
    expect(result.errors.count).to eq(0)
	  params = read_yaml(sub_dir, "version_property_1.yaml")
		property = Study::Form::BcProperty.construct(params)
  	property.variables << result
    expect(result.origin).to eq("CRF")
  end

  it 'detects if terminology can be edited' do
    params = {short_name: "VSABC", name: "Test name", ordinal: 3, version_uuid: "1234-5678", user: false, used: true, core: :required, previous_used: true, role: "XXX"}
    variable = Study::Variable.construct(params, @ref)
    term = MdrHelpers.create_thesaurus_concept()
    source = Study::Source.construct({version_uuid: "1234-1234"})
    params ={from_node: source, to_node: term, enabled: true, ordinal: 1, optional: false}
    result = Mdr::HasTc.construct(params)
    expect(variable.terminology_editable?).to eq(false)
    source.variable = variable
    expect(variable.terminology_editable?).to eq(true)
  end

  it 'comment?'
  it 'comments?'
  it 'comment'
  it 'comments_bar'
  it 'comment_text'
  it 'update_comment(id)'
  it 'remove_comment'
  it 'derivation_text'
  it 'toggle'
	it 'set_used'
	it 'study_version'
  it 'parent'
  it 'delete'
	
end
