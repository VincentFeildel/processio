# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

# Suppression DB events

events = Event.all
events.each { |e| e.destroy }

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
u.first_name = 'Vincent'
u.last_name = 'Feildel'
u.position = 'Gérant'
u.save

# -------------------DB CONTRATS---------------



# Génération de la DB de contrats
csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }
filepath    = 'db/Seed_leasy.csv'


#Initialisation dates:
incr = Date.today - Date.new(2017,4,15)


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
  l.end_date = Date.strptime(row['end_date'],'%m/%d/%Y') + incr.days
  l.nature = row['nature']

  # rent
  l.monthly_rent = row['monthly_rent']
  l.rent_balance = row['rent_balance']
  l.overdue_days = row['overdue_days']
  l.next_revision = Date.strptime(row['next_revision'],'%m/%d/%Y') + incr.days
  l.save
end
puts '----------------'
puts 'Contrats de bail créés!!'

# Génération des évènements

Lease.all.each do |lease|
  now = Date.today

  # Fin de bail
  if now > lease.end_date - 8.months
    e = Event.new()
    e.description = 'fin de bail'
    e.lease = lease
    e.start_date = lease.end_date - 7.months
    e.end_date = lease.end_date - 6.months
    e.urgent_date = e.end_date - 1.weeks
    e.status = 'owner_to_contact'
    # emergency level
    if now >= e.end_date
      e.emergency_level = 'overdue'
    elsif now >= e.urgent_date
      e.emergency_level = 'urgent'
    elsif now >= e.start_date
      e.emergency_level = 'due'
    else
      e.emergency_level = 'non-due'
    end
    e.to_do = true
    e.save
    e.delete if e.emergency_level == 'overdue'
  # Revision de loyer
  elsif now > lease.next_revision - 2.months
    e = Event.new()
    e.description = 'révision de loyer'
    e.lease = lease
    e.start_date = lease.next_revision - 1.month
    e.end_date = lease.end_date - 7.months
    e.urgent_date = lease.next_revision
    e.status = 'owner_to_contact'
    # emergency level
    if now >= e.end_date
      e.emergency_level = 'overdue'
    elsif now >= e.urgent_date
      e.emergency_level = 'urgent'
    elsif now >= e.start_date
      e.emergency_level = 'due'
    else
      e.emergency_level = 'non-due'
    end
    e.to_do = true
    e.save
  end

  # loyer
  if lease.rent_balance > 0
    e = Event.new()
    e.description = 'retard loyer'
    e.lease = lease
    e.start_date = now
    e.end_date = now
    e.urgent_date = now
    e.status = 'tenant_to_notify'
    # emergency level
    if now >= e.end_date
      e.emergency_level = 'overdue'
    elsif now >= e.urgent_date
      e.emergency_level = 'urgent'
    elsif now >= e.start_date
      e.emergency_level = 'due'
    else
      e.emergency_level = 'non-due'
    end
    e.to_do = true
    e.save
  end

end
puts '----------------'
puts 'Evenements créés!!'

# Indiquer 50 tâches comme réalisées:
Event.where(description: 'fin de bail').last(50).each do |e|
  e.update(status: 'tenant_notified', to_do: false)
end


# Indiquer 50 tâches comme en cours:
Event.first(70).each do |e|
  e.update(status: 'tenant_to_notify') if e.description != 'retard loyer'
end
puts '----------------'
puts 'Evenements en cours et réalisés modifiés'
# Création de la db du graph
BalanceDay.all.each { |bd| bd.destroy }

now = Date.today
balt = Lease.sum(:rent_balance)
sum_rents_last = Lease.sum(:monthly_rent)
sum_rents = sum_rents_last - 12000
bal = balt + 12000

for i in 0..5
  day = now - (6 - i).months
  bal -= rand(0..4000)
  sum_rents += rand(0..4000)
  BalanceDay.create(day: day, balance: bal, all_rents: sum_rents)
end
BalanceDay.create(day: now, balance: balt, all_rents: sum_rents_last)

puts '----------------'
puts 'DB graph créée'
puts ':)'

# populate indice table
if Indice.all.count == 0
  Indice.all.each { |i| i.destroy }
  filepath = 'db/indices.csv'

  CSV.foreach(filepath, csv_options) do |row|
    date = Date.strptime(row['app_date'],'%m/%d/%Y')
    indice = row['indice']
    Indice.create(app_date: date, indice: indice)
  end
end

puts '----------------'
puts 'Indices loyer créés!!'
