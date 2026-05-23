thomas = Doctor.create!(name: 'Thomas', specialty: 'Cardiology', age: 25)
nina = Doctor.create!(name: 'Nina', specialty: 'Psychology', age: 25)

scooter = Patient.create!(name: 'scooter', age: 30)
cassandra = Patient.create!(name: 'cassandra', age: 30)

Appointment.create(patient_id: scooter.id, doctor_id: nina.id)
Appointment.create(patient_id: cassandra.id, doctor_id: thomas.id)
