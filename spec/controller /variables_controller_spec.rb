require 'rails_helper'

describe Studies::VariablesController, type: :controller do
  
  include UserAccountHelpers
  include Neo4jHelpers
  include StudyHelpers
  include MdrHelpers
  include FileHelpers
  include JsonHelpers

  def sub_dir
    return "controllers"
  end

  def new_variable
    uri = Uri.new({uri: "http://www.test.uk/a"})
    params = {uri: uri.to_s, name: "Whoa", identifier: "XXX", owner: "CDISC", semantic_version: "1.2.3"}
    return Mdr::Variable.construct(params)
  end

  def new_comment
    comment = "We did it this way"
    params = {comment: comment, scope: "DM.XXX"}
    return Mdr::Comment.construct(params)
  end

  describe "Edit Access" do

    before :all do
      ua_create
    end

    after :all do
      ua_destroy
    end

    before :each do
      neo4j_clear
      login_with_edit_access

      @version = StudyHelpers.create_study_version
      Study.all.destroy_all
      Mdr::Reference.destroy_all
      params = {name: "Study 1", identifier: "XXXX", source: :mdr}
      DefineXml::Document.create(:default=>true, :semantic_version => "Sem1.2")

      Mdr::Terminology.create(name: "Med 19.0.0", uri: "https://www.med.org/v19.0", identifier: "CDISC Terminology", owner: "CDISC", semantic_version: "19.0.1", default: true)

      Mdr::Terminology.create(name: "Med 19.0.0", uri: "https://www.med1.org/v19.0", identifier: "SDTM IG", owner: "SDTM", semantic_version: "19.0.0", default: true)

      Mdr::SdtmIg.create(default: true, identifier: "CDISC Terminology", name: "CDISC Implementation Guide 2013-11-26", owner: "CDISC", semantic_version: "3.1.2", uri: "http://www.assero.co.uk/MDRSdtmIg/CDISC/V3#IG-CDISC_SDTMIG")

      Mdr::SdtmIg.create(default: true, identifier: "SDTM IG", name: "SDTM Implementation Guide 2013-11-26", owner: "SDTM", semantic_version: "3.1.3", uri: "http://www.assero1.co.uk/MDRSdtmIg/CDISC/V3#IG-CDISC_SDTMIG")

      Mdr::Reference.create(identifier: "CDISC Terminology", default: true)
      Mdr::Reference.create(identifier: "SDTM IG", default: true)

      @study =Study.construct(params)

      sdtm_ig = Study::SdtmIg.create( default_values: nil, used: true,version_uuid: @version.id)

      params = {  default_values: nil, keys: "STUDYID, USUBJID, QSCAT, QSTESTCD, QSDTC, VISITNUM",
                  name: "Questionnaires", prefix: "QS", sdtm_class: "Findings", structure: "",
                  used: false, user: false, version_uuid: @version.id}
      @based_on = MdrHelpers.create_domain({})
      @domain = Study::Domain.construct(params, @based_on)
      @study.study_versions << @version
      sdtm_ig.domains << @domain
      @version.sdtm_ig = sdtm_ig

      params = { short_name: "VSABC", name: "Test name", ordinal: 3, user: false,
                 used: true, core: :required, previous_used: true, version_uuid:  @version.id,
                 role: "X" }
      @variable = Study::Variable.construct(params, @ref)

      @domain.variables << @variable

      @mdr_comment = Mdr::Comment.construct({comment: "Comment 1", scope: "DM.XXX"})
      @mdr_variable = MdrHelpers.create_variable
      @variable.comment_used = @mdr_comment
      @variable.based_on = @mdr_variable
    end

    after :each do
    end

    it "index" do
      get :index, { study_variable: { domain_id:  @domain.id }}
      expect(response.code).to eq("200")
    end

    it "show" do
      get :show, {id: @variable.id , study_variable: {domain_id:  @domain.id  }}
      expect(response.code).to eq("200")
    end

    it "update comment" do
      put :update_comment, {id: @variable.id , study_variable: {domain_id:  @domain.id ,comment_id: @mdr_comment.id   }}
      expect(response).to redirect_to(studies_variable_path({ id: @variable.id, study_variable: { domain_id: @domain.id }}))
    end

    it "remove comment" do
      put :remove_comment, {id: @variable.id , study_variable: {domain_id:  @domain.id   }}
      expect(response).to redirect_to(studies_variable_path({ id: @variable.id, study_variable: { domain_id: @domain.id }}))
    end
    it "update derivation" do
      mdr_comment = Mdr::Comment.construct({comment: "We did it this way", scope: "DM.XXX"})
      derivation = "dummy dummy"
      params = {name: "test1", description: derivation, formal_expression: "hcvhgvcgvc"}
      mdr_derivation = Mdr::Derivation.construct(params)
      @variable.derivation_used = mdr_derivation
      put :update_derivation, {id: @variable.id, study_variable: { derivation_id: Mdr::Derivation.last.id, domain_id:  @domain.id} }
      expect(response).to redirect_to(studies_variable_path({ id: @variable.id, study_variable: { domain_id: @domain.id }}))
    end
    it "remove derivation" do
      put :remove_derivation, {id: @variable.id , study_variable: {domain_id:  @domain.id   }}
      expect(response).to redirect_to(studies_variable_path({ id: @variable.id, study_variable: { domain_id: @domain.id }}))
    end

    it "status" do
      get :status, {id: @variable.id}
      expect(response.code).to eq("200")
    end

    it "toggle" do
      get :toggle, {id: @variable.id}
      expect(response.code).to eq("200")
    end

  end

  describe "Unauthorized User" do

    it "index" do
      get :index
      expect(response).to redirect_to("/users/sign_in")
    end

    it "show" do
      get :show, id: 3
      expect(response).to redirect_to("/users/sign_in")
    end

    it "update comment" do
      put :update_comment, id: 1
      expect(response).to redirect_to("/users/sign_in")
    end

    it "remove comment" do
      put :remove_comment, id: 1
      expect(response).to redirect_to("/users/sign_in")
    end

    it "update derivation" do
      put :update_derivation, id: 1
      expect(response).to redirect_to("/users/sign_in")
    end

    it "remove derivation" do
      put :remove_derivation, id: 1
      expect(response).to redirect_to("/users/sign_in")
    end

    it "status" do
      get :status, id: 1
      expect(response).to redirect_to("/users/sign_in")
    end

    it "toggle" do
      put :toggle, id: 1
      expect(response).to redirect_to("/users/sign_in")
    end

  end

end

