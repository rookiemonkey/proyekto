require_relative 'seeds/organization_seed'
require_relative 'seeds/user_seed'
require_relative 'seeds/user_accessible_seed'
require_relative 'seeds/project_seed'
require_relative 'seeds/artifact_seed'

Seeds::Organization.produce
Seeds::User.produce
Seeds::UserAcessible.produce
Seeds::Project.produce
Seeds::Artifact.produce