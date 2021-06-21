module Seeds
  class Project
    @@count = 10
    @@all = nil

    def self.produce
      Seeds::Organization.all.each do |organization| 
        @@count.times do 
          new_project_name = Faker::Movie.title

          ::Project.create(name: new_project_name, organization: organization)
          ::Activity.create(description: "[SEEDER]: Project '#{new_project_name}'' has been created",
                            organization: organization,
                            activity_type: 'project')
        end
      end

      @@all = ::Project.where(organization: Seeds::Organization.current_tenant)
      @@one = @@all.sample
    end

    def self.all
      @@all
    end
  end
end