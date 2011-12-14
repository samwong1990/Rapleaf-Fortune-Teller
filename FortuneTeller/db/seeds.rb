# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Query.delete_all
#...
Query.create(
        name: 'Sam Wong',
        email: 's@mwong.hk',
        dataset: 's@mwong.hk onlineshoppingalias@gmail.com sw2309@imperial.ac.uk'
        )