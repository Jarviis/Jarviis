team = Team.where(name: "Admins").first_or_initialize
team.save!

admin = User.where(email: 'admin@example.com').first_or_initialize
admin.name = "Admin"
admin.username = "admin"
admin.password = "jarviis"
admin.teams << team
admin.save!
