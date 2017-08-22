# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

# Suppression DB contrats

leases = Lease.all
leases.each { |l| l.destroy }


#Nettoyage utilisateur

users = User.all
users.each { |u| u.destroy }

# Création de l'utilisateur
u = User.new()
u.email = 'vincent.feildel@gmail.com'
u.password = 'azerty'
u.save

# -------------------DB CONTRATS---------------



# Génération de la DB de contrats
csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }
filepath    = 'db/Seed_leasy.csv'

CSV.foreach(filepath, csv_options) do |row|
  l = Lease.new()
  # user
  l.user = u

  #tenant
  l.tenant_company = row['tenant_company']
  l.tenant_first_name = row['tenant_first_name']
  l.tenant_name = row['tenant_name']
  l.tenant_gender = row['tenant_gender']
  l.tenant_address = row['tenant_address']

  # owner
  l.owner_name = row['owner_name']
  l.owner_email = row['owner_email']
  l.owner_address = row['owner_address']

  l.num_lot = row['num_lot']
  l.end_date = Date.strptime(row['end_date'],'%m/%d/%Y')
  l.nature = row['nature']

  # rent
  l.monthly_rent = row['monthly_rent']
  l.rent_balance = row['rent_balance']
  l.overdue_days = row['overdue_days']
  l.next_revision = Date.strptime(row['next_revision'],'%m/%d/%Y')

  row['owner_name']
  l.save
end
