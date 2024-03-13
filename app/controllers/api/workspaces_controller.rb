# TODO: this controller needs special auth with the workspaces backend
module Api
  class WorkspacesController < ApiController
    before_action :check_api_readable
    before_action :set_request_formats
    # before_action :authorize

    # authorize_resource
    skip_authorization_check

    around_action :api_call_handle_error, :api_call_timeout

    def create
      workspace_schema = "workspace-#{params[:id]}"

      # This runs the migrations that scaffold all of the OSM tables into a new
      # schema. We don't need every table, but we can't choose. The global non-
      # tenant tables match excluded models in config/initializers/apartment.rb
      # that Apartment associates with the "public" schema.
      #
      Apartment::Tenant.create(workspace_schema)
      Apartment::Tenant.switch!(workspace_schema)

      # Drop tables that shadow the "public" schema. These tables cause foreign
      # key constraint issues for tenant tables. The migrations include all OSM
      # tables, and any unqualified references resolve to tenant schema tables.
      # Removing these tables from the search path causes PostgreSQL to resolve
      # tables references from the "public" schema instead:
      #
      connection = ActiveRecord::Base.connection
      connection.execute("DROP TABLE \"#{workspace_schema}\".users CASCADE")
    end

    def destroy
      Apartment::Tenant.drop("workspace-#{params[:id]}")
    end
  end
end

# TODO: stub
class Workspace
end
