require 'rails_helper'

describe 'studies/variables/show.html.erb', :type => :view do

  include UserAccountHelpers
  include ViewHelpers
  include Neo4jHelpers
  include MdrHelpers
  include StudyHelpers
  
  before :each do
    neo4j_clear
  end

  it 'allows domain info to be viewed' do
    
    def view.policy(name)
      # Do nothing
    end

		mdr_domain = MdrHelpers.create_domain
    mdr_variable = MdrHelpers.create_variable
    study = StudyHelpers.create_study
    study_version = StudyHelpers.create_study_version
    domain = StudyHelpers.create_domain({prefix: "AE"}, mdr_domain)
    variable = StudyHelpers.create_variable({controlled_term_or_format: "ABC"}, mdr_variable)
    comments = variable.comments_bar
		current_comment = variable.comment
		derivations = variable.derivations_bar
		current_derivation = variable.derivation
    assign(:variable, variable)
    assign(:domain, domain)
    assign(:study, study)
    assign(:study_version, study_version)
    assign(:comments, comments)
    assign(:current_comment, current_comment)
    assign(:derivations, derivations)
    assign(:current_derivation, current_derivation)

    render

    #page_to_s

    expect(rendered).to have_content("Variable Information")
    expect_table_header_cell_text("variable_info", 1, "Name")
    expect_table_cell_text("variable_info", 1, 1, "AETEST")
    expect_table_header_cell_text("variable_info", 2, "Label")
    expect_table_cell_text("variable_info", 2, 1, "testy testy")
    expect_table_header_cell_text("variable_info", 3, "Key Position")
    expect_table_cell_text("variable_info", 3, 1, "")
    expect_table_header_cell_text("variable_info", 4, "Datatype")
    expect_table_cell_text("variable_info", 4, 1, "Char")
    expect_table_header_cell_text("variable_info", 5, "Length")
    expect_table_cell_text("variable_info", 5, 1, "")
    expect_table_header_cell_text("variable_info", 6, "Format")
    expect_table_cell_text("variable_info", 6, 1, "ABC")
    expect_table_header_cell_text("variable_info", 7, "Origin")
    expect_table_cell_text("variable_info", 7, 1, "Assigned")

    expect_link_href(studies_variables_path(study_variable: { domain_id: domain.uuid }))
  end

end