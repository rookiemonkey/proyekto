module Seeds
  class Artifact
    @@count = 10

    def self.produce
      Seeds::Organization.current_tenant.projects.each do |project|
        @@count.times do
          project.artifacts << ::Artifact.create( name: Faker::Construction.material,
                                                  description: Faker::Quote.famous_last_words)
        end
      end
    end
  end
end