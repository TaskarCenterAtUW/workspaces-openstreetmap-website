require "apartment/elevators/generic"

class WorkspacesElevator < Apartment::Elevators::Generic
  def parse_tenant_name(request)
    return nil if request.path.match?(%r{^/api/[0-9.]+/workspaces/})

    workspace_id = request.env["HTTP_X_WORKSPACE"] # X-Workspace header

    return nil if workspace_id.blank?
    return nil unless workspace_id.match?(/^\d+$/)

    logger.info("Selecting workspace #{workspace_id}")

    "workspace-#{workspace_id}"
  end
end
