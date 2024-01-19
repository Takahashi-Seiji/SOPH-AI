Rails.logger.debug "Truncating all tables (except schema_migrations)..."
ActiveRecord::Base.establish_connection
ActiveRecord::Base.connection.tables.each do |table|
  ActiveRecord::Base.connection.execute("TRUNCATE #{table} CASCADE") unless table == "schema_migrations"
end


# # This file should ensure the existence of records required to run the application in every environment (production,
# # development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# # The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
# #
# # Example:
# #
# #   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
# #     MovieGenre.find_or_create_by!(name: genre_name)
# #   end

# student = User.new(
#   email: "student@email.com",
#   password: "123456",
#   role: "student",
#   first_name: "Anakin",
#   last_name: "Skywalker",
#   institution: "Jedi Academy"
# )

# teacher = User.new(
#   email: "teacher@email.com",
#   password: "123456",
#   role: "teacher",
#   first_name: "Obi-Wan",
#   last_name: "Kenobi",
#   institution: "Jedi Academy"
# )

# Lecture.create!(
#   teacher: teacher,
#   title: "The Force",
#   content: "The Force is a metaphysical and ubiquitous power in the Star Wars fictional universe. It is wielded by characters in the franchise's films and in many of its spin-off books, games, and comics. In the story, the Jedi utilize the light side of the Force, while the Sith exploit what is known as the dark side. The Force has been compared to aspects of several world religions, and the phrase \"May the Force be with you\" has become part of the popular-culture vernacular.",
#   shareable_link: SecureRandom.hex(10),
#   date: Date.today,
#   lecture_number: 1,
#   instructions: "Hello GPT, my student is a highschool student and he is struggling with the concept of the force. Please explain to him what the force is and how it works. Thank you.",
#   summary: "summary needed"
# )
