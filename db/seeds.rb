@user = User.create(email: "test@test.com",
                    password: "asdfasdf",
                    password_confirmation: "asdfasdf",
                    first_name: "John",
                    last_name: "Smith",
                    phone: "9784010064")

puts "1 user created"

AdminUser.create(email: "admin@test.com",
                 password: "asdfasdf",
                 password_confirmation: "asdfasdf",
                 first_name: "Admin",
                 last_name: "Johnson",
                 phone: "9784010064")

puts "1 admin user created"

100.times do |post|
  Post.create!(date: Date.today, rationale: "#{post} rationale content Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.", overtime_request: 2.5, user_id: @user.id )
end

puts "100 posts have been created!"

AuditLog.create!(user_id: @user.id, status: 0, start_date: Date.today - 6.days)
AuditLog.create!(user_id: @user.id, status: 0, start_date: Date.today - 13.days)
AuditLog.create!(user_id: @user.id, status: 0, start_date: Date.today - 20.days)

puts "3 audit logs have been created!"
