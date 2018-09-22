require 'rails_helper'

describe StudiesController, type: :controller do

  include UserAccountHelpers
  include Neo4jHelpers
  include StudyHelpers
  include MdrHelpers
  include FileHelpers
  include JsonHelpers

  def sub_dir
    return "controllers"
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
    end

    after :each do
    end

    it "new from mdr" do
      get :new_from_mdr
      expect(response.code).to eq("200")
    end

    it "new from define" do
      get :new_from_define
      expect(response.code).to eq("200")
    end

    it "indexes" do
      get :index
      expect(response.code).to eq("200")
    end

    it "history" do
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

      get :history, id:@study.id

      expect(response.code).to eq("200")
    end

    it "creates" do
      get :create , { study: {name: "Study 1", identifier: "XXXX", source: :mdr }}
      expect(response.code).to eq("422")

      version = StudyHelpers.create_study_version
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
      get :create , { study: {name: "Study 1", identifier: "rttrytr" ,source: :mdr }}
      expect(response.code).to eq("200")
    end

    it "destroys" do
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

      get :destroy, id: @study.id

      expect(response).to redirect_to(studies_path)
    end

  end

  describe "Unauthorized User" do

    it "new from mdr" do
      get :new_from_mdr
      expect(response).to redirect_to("/users/sign_in")
    end

    it "new from define" do
      get :new_from_define
      expect(response).to redirect_to("/users/sign_in")
    end

    it "indexes" do
      get :index
      expect(response).to redirect_to("/users/sign_in")
    end

    it "history" do
      get :history, id: 1
      expect(response).to redirect_to("/users/sign_in")
    end

    it "creates" do
      post :create
      expect(response).to redirect_to("/users/sign_in")
    end

    it "destroys" do
      delete :destroy, id: 1
      expect(response).to redirect_to("/users/sign_in")
    end

  end

end

