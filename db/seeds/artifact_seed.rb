module Seeds
  class Artifact
    @@count = 10

    def self.produce
      Seeds::Organization.current_tenant.projects.each do |project|
        @@count.times do
          new_artifact = ::Artifact.create( name: Faker::Construction.material,
                                            description: Faker::Quote.famous_last_words)

          ::Activity.create(description: "[SEEDER]: Artifact '#{new_artifact.name}'' has been created",
                            organization:  project.organization,
                            activity_type: 'artifact')

          project.artifacts << new_artifact
          Seeds::Organization.current_tenant.artifacts << new_artifact
        end
      end
    end
  end
end