class Studies::VariablesController < ApplicationController

	before_action :authenticate_user!
  before_action :authorized?

  C_CLASS_NAME = self.class.to_s

  def index
    @domain = Study::Domain.find(the_params[:domain_id])
    @study_version = @domain.study_version
    @study = @study_version.parent
  end

  def show
		@variable = Study::Variable.find(params[:id])
		@domain = Study::Domain.find(the_params[:domain_id])
    @study_version = @domain.study_version
    @study = @study_version.parent
		@comments = @variable.comments_bar
		@current_comment = @variable.comment
		@derivations = @variable.derivations_bar
		@current_derivation = @variable.derivation
	end

	def update_comment
		@variable = Study::Variable.find(params[:id])
		@variable.update_comment(the_params[:comment_id])
		@domain = Study::Domain.find(the_params[:domain_id])
		@comments = @variable.comments_bar
		@current_comment = @variable.comment
		redirect_to studies_variable_path({ id: @variable.id, study_variable: { domain_id: @domain.id }})
	end

	def remove_comment
		@variable = Study::Variable.find(params[:id])
		@variable.remove_comment
		@domain = Study::Domain.find(the_params[:domain_id])
		@comments = @variable.comments_bar
		@current_comment = @variable.comment
		redirect_to studies_variable_path({ id: @variable.id, study_variable: { domain_id: @domain.id }})
	end

	def update_derivation
		@variable = Study::Variable.find(params[:id])
		@variable.update_derivation(the_params[:derivation_id])
		@domain = Study::Domain.find(the_params[:domain_id])
		@derivations = @variable.derivations_bar
		@current_derivation = @variable.derivation
		redirect_to studies_variable_path({ id: @variable.id, study_variable: { domain_id: @domain.id }})
	end

	def remove_derivation
		@variable = Study::Variable.find(params[:id])
		@variable.remove_derivation
		@domain = Study::Domain.find(the_params[:domain_id])
		@derivations = @variable.derivations_bar
		@current_derivation = @variable.derivation
		redirect_to studies_variable_path({ id: @variable.id, study_variable: { domain_id: @domain.id }})
	end

	def status
		variable = Study::Variable.find(params[:id])
		render :json => {status: variable.used}, :status => 200
	end

	def toggle
		variable = Study::Variable.find(params[:id])
		updated = variable.toggle
		render :json => {status: updated.used}, :status => 200
	end

private

	def authorized?
    authorize Study::Variable
  end

  def the_params
  	params.require(:study_variable).permit(:domain_id, :comment_id, :derivation_id)
	end  

end