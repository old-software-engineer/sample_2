class StudiesController < ApplicationController

	before_action :authenticate_user!
  before_action :authorized?

  C_CLASS_NAME = "StudiesController"
  TBS = "To Be Set"

  def new_from_mdr
    @close_path = studies_path
  end

	def new_from_define
    @files = Upload.xml_files
    @upload = Upload.new
    @close_path = studies_path
  end
  
	def index
    @studies = Study.all
	end

	def history
    @study = Study.find(params[:id])
    @study_versions = @study.history
  end

	def create
    study = Study.construct(the_params)
    render :json => {operation_path: load_studies_version_path(study.study_versions.first), close_path: history_study_path(study)}, :status => 200
  rescue => e
    render :json => { errors: [e.message] }, :status => 422
  end

	def destroy
		study = Study.find(params[:id])
		study.delete
    redirect_to studies_path
	end

private

	def authorized?
    authorize Study
  end

  def the_params
  	params.require(:study).permit(:source, :identifier, :name, :study_id, :study_version_id, :filename)
	end  

end