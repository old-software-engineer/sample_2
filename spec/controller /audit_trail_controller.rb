class AuditTrailController < ApplicationController
  
  before_action :authenticate_user!
  before_action :set_audit_trail, only: [:show, :edit, :update, :destroy]
  
  C_CLASS_NAME = "AuditTrailsController"
  C_RECORDS = 2000

  def index
    authorize AuditTrail
    @items = AuditTrail.last(C_RECORDS)
    @defaults = {:user => "", :identifier => "", :owner => "", :event => AuditTrail.event_types[:empty_action]}
    users_owners_events
  end

  def search
    authorize AuditTrail
    param_set = the_params
    remove_key(param_set, :user, "")
    remove_key(param_set, :identifier, "")
    remove_key(param_set, :owner, "")
    remove_key(param_set, :event, AuditTrail.event_types[:empty_action].to_s)
    @items = AuditTrail.where(param_set).all
    @defaults = the_params
    users_owners_events
    render "index"
  end

  def export_csv
    authorize AuditTrail
    send_data AuditTrail.to_csv, filename: "audit_trail.csv", :type => 'text/csv; charset=utf-8; header=present', disposition: "attachment"
  end

private

  def set_audit_trail
    @audit_trail = AuditTrail.find(params[:id])
  end

  def the_params
    params.require(:audit_trail).permit(:user, :identifier, :owner, :event)
  end

  def users_owners_events
    @users = User.all
    @users.unshift(User.new)
    @events = AuditTrail.event_types
  end

  def remove_key(params, key, value)
    if params[key] == value
      params.delete key
    end
  end

end
