require 'apartment/elevators/generic'

class WorkspacesElevator < Apartment::Elevators::Generic
  def parse_tenant_name(request)
    return nil if request.path.match? /^\/api\/[0-9.]+\/workspaces\//

    workspace_id = request.env['HTTP_X_WORKSPACE'] # X-Workspace header

    if workspace_id.blank?
      workspace_id = request.cookies['workspace']
    end

    return nil if workspace_id.blank?
    return nil unless workspace_id.match? /^\d+$/

    puts 'Selecting workspace ' + workspace_id

    return 'workspace-' + workspace_id
  end
end
