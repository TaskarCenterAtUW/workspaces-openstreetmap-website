require 'apartment/elevators/generic'

class WorkspacesElevator < Apartment::Elevators::Generic
  def parse_tenant_name(request)
    workspace_id = request.headers['X-Workspace']

    return nil if workspace_id.blank?
    return nil unless workspace_id.numeric?

    return 'workspace-' + workspace_id
  end
end
