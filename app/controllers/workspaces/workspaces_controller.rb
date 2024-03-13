# TODO: this controller needs special auth with the workspaces backend
module Workspaces
  class WorkspacesController < ApiController
    before_action :check_api_readable
    before_action :set_request_formats

    authorize_resource

    around_action :api_call_handle_error, :api_call_timeout

    def create
      Apartment::Tenant.create(params[:id])
    end

    def drop
      Apartment::Tenant.drop(params[:id])
    end
  end
end
