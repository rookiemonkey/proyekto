module Seeds
  class Project
    @@count = 10
    @@all = nil

    def self.produce
      Seeds::Organization.all.each do |organization| 
        @@count.times { ::Project.create(name: Faker::Movie.title, organization: organization) }
      end

      @@all = ::Project.where(organization: Seeds::Organization.current_tenant)
      @@one = @@all.sample
    end

    def self.all
      @@all
    end
  end
end