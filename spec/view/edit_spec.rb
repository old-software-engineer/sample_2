require 'rails_helper'

describe 'studies/forms/edit.html.erb', :type => :view do

  it 'Edit Form View' do

    def view.policy(name)
      # Do nothing
    end

    user = User.create :email => "user@assero.co.uk", :password => "cHangeMe14%", :name => "User Fred"

    Study::Version.delete_all
    Study::Form.delete_all
    Study.delete_all

    version = StudyHelpers.create_study_version
    study = StudyHelpers.create_study
    study.study_versions << version
    form = StudyHelpers.create_study_form({name: "F1", uri: "http://www.example.com#F1", ordinal: 1, identifier: "FORM 1"}, version )

    allow(view).to receive(:policy).and_return double(new?: true)
    allow(view).to receive(:current_user).and_return(user)
    assign(:form, form)
    assign(:study_version, version)
    assign(:study, study)

    render

    # Link
    expect(rendered).to have_link('Study', href: edit_studies_version_path(version))
    expect(rendered).to have_link('SoA', href: soa_studies_version_path(version) )
    expect(rendered).to have_link('Detail', href: detail_studies_version_path(version) )
    expect(rendered).to have_link('CRF', href: crf_studies_version_path(version) )
    expect(rendered).to have_link('aCRF', href: acrf_studies_version_path(version))
    expect(rendered).to have_link('Domains', href: studies_domains_path({study_domain: {study_version_id: version.uuid}}))
    expect(rendered).to have_link('Documents', href:  studies_documents_path({study_document: {study_version_id: version.uuid}}))
    expect(rendered).to have_link('Terminologies',  href: studies_terminologies_path({study_terminology: {study_version_id: version.uuid}}) )
    expect(rendered).to have_selector("#form_nav.active a", text: 'Form') #form is active

    # Content
    expect(rendered).to have_content("Form: F1 (FORM 1)")
    expect(rendered).to have_content("F1")
    expect(rendered).to have_content("Identifier")
    expect(rendered).to have_content("Label")

    # HTML Tags
    expect(rendered).to have_css(".input-group")
    expect(rendered).to have_css(".form-control")
    expect(rendered).to have_css(".input-group-btn")

    # Buttons
    expect(rendered).to have_selector("button#d3_minus")
    expect(rendered).to have_selector("button#d3_plus")

  end

end