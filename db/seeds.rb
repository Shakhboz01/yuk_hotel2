# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
User.create(name: "Jamshed", email: "jamshed@gmail.com", password: "jamshed123")
User.create(name: "Admin", email: "admin@gmail.com", password: "admin111")

Home.create(number: 1, number_of_people: 2, home_type: 0, price: 500000)
Home.create(number: 2, number_of_people: 2, home_type: 0, price: 500000)
Home.create(number: 3, number_of_people: 4, home_type: 0, price: 800000)
Home.create(number: 4, number_of_people: 3, home_type: 0, price: 600000)
Home.create(number: 5, number_of_people: 2, home_type: 0, price: 400000)

Home.create(number: 14, number_of_people: 3, home_type: 1, price: 450000)
Home.create(number: 15, number_of_people: 3, home_type: 1, price: 450000)
Home.create(number: 16, number_of_people: 8, home_type: 1, price: 1200000)
Home.create(number: 17, number_of_people: 2, home_type: 1, price: 300000)
Home.create(number: 18, number_of_people: 2, home_type: 1, price: 300000)
