# Seed data ported from the React prototype (tmp/writeup.md).
# Idempotent: clears and rebuilds the demo agent's data on each run.

puts "Seeding tourvi demo data..."

Agent.where(email: "janey@fatbirdmarketing.com").destroy_all

agent = Agent.create!(
  email: "janey@fatbirdmarketing.com",
  password: "tourvi123",
  name: "Janey Hawley",
  phone: "720-555-0101",
  brokerage: "Fat Bird Realty",
  license_number: "CO-RE-284910",
  title: "Realtor",
  bio: "Denver native with 12 years in residential real estate. Specializing in urban neighborhoods and first-time buyers.",
  profile_color: "#C9A96E"
)

clients_data = [
  { name: "Sarah & Mike Chen", email: "chen@email.com", phone: "720-555-0142", notes: "Budget $500-650k. 3+ beds. Pre-approved.", stage: "Touring", budget: "$500k-$650k", pre_approved: "Yes", pre_approval_amount: "$650,000" },
  { name: "Jordan Patel", email: "jpatel@email.com", phone: "303-555-0198", notes: "Condo or townhome. Flexible on location.", stage: "Touring", budget: "$350k-$420k", pre_approved: "Yes", pre_approval_amount: "$420,000" },
  { name: "Amanda Reyes", email: "areyes@email.com", phone: "720-555-0231", notes: "First-time buyer. Loves RiNo and LoHi.", stage: "Touring", budget: "$425k-$500k", pre_approved: "Yes", pre_approval_amount: "$495,000" },
  { name: "Marcus & Talia Webb", email: "mwebb@email.com", phone: "303-555-0374", notes: "4+ beds. Dogs, need yard.", stage: "Touring", budget: "$700k-$800k", pre_approved: "Yes", pre_approval_amount: "$800,000" },
  { name: "Derek Nguyen", email: "dnguyen@email.com", phone: "720-555-0412", notes: "Investor. Looking for duplex or strong rental.", stage: "Searching", budget: "$500k-$600k", pre_approved: "No", pre_approval_amount: "" },
  { name: "Priya Sharma", email: "psharma@email.com", phone: "303-555-0589", notes: "Needs home office. Budget up to $450k.", stage: "Under Contract", budget: "Up to $450k", pre_approved: "Yes", pre_approval_amount: "$450,000" },
  { name: "Tom & Lisa Kowalski", email: "tkowalski@email.com", phone: "720-555-0663", notes: "Moving from Chicago. Want walkable neighborhood.", stage: "Closed", budget: "$650k-$700k", pre_approved: "Yes", pre_approval_amount: "$700,000" },
  { name: "Brittany Monroe", email: "bmonroe@email.com", phone: "303-555-0717", notes: "Budget $350-425k. Wants low maintenance.", stage: "Closed", budget: "$350k-$425k", pre_approved: "Yes", pre_approval_amount: "$425,000" },
  { name: "James & Keisha Odom", email: "jodom@email.com", phone: "720-555-0845", notes: "5 kids. Schools are top priority.", stage: "Closed", budget: "$520k-$580k", pre_approved: "Yes", pre_approval_amount: "$575,000" },
  { name: "Carlos Mendez", email: "cmendez@email.com", phone: "303-555-0921", notes: "Wants character home, older neighborhoods.", stage: "Searching", budget: "$400k-$500k", pre_approved: "No", pre_approval_amount: "" }
]

clients = clients_data.map { |attrs| agent.clients.create!(attrs) }

tours_data = [
  { client: 1, name: "Denver Hills Tour", date: "2026-06-03", time: "10:00 AM", status: "confirmed", post_notes: "", properties: [
    { address: "4821 Larimer St", city: "Denver, CO 80216", beds: 3, baths: 2, price: "$485,000", notes: "Great natural light, HOA $120/mo.", mls_id: "MLS-1042" },
    { address: "912 Clarkson Ave", city: "Denver, CO 80218", beds: 4, baths: 3, price: "$612,000", notes: "Newer kitchen, slightly over budget.", mls_id: "MLS-2891" },
    { address: "2200 S Josephine St", city: "Denver, CO 80210", beds: 3, baths: 2, price: "$529,000", notes: "", mls_id: "MLS-3310" }
  ] },
  { client: 2, name: "Wash Park Condos", date: "2026-06-07", time: "2:00 PM", status: "draft", post_notes: "", properties: [
    { address: "550 E Cedar Ave #4B", city: "Denver, CO 80209", beds: 2, baths: 2, price: "$398,000", notes: "Top floor. Parking included.", mls_id: "MLS-5512" }
  ] },
  { client: 1, name: "Highlands Weekend", date: "2026-06-10", time: "11:00 AM", status: "confirmed", post_notes: "", properties: [
    { address: "3301 Osceola St", city: "Denver, CO 80212", beds: 4, baths: 3, price: "$725,000", notes: "Fully renovated, original hardwoods.", mls_id: "MLS-4401" },
    { address: "4150 W 38th Ave", city: "Denver, CO 80212", beds: 3, baths: 2, price: "$658,000", notes: "Corner lot, big backyard.", mls_id: "MLS-4402" },
    { address: "3825 Meade St", city: "Denver, CO 80211", beds: 3, baths: 3, price: "$689,000", notes: "", mls_id: "MLS-4403" },
    { address: "4420 Utica St", city: "Denver, CO 80212", beds: 5, baths: 4, price: "$810,000", notes: "Over budget but spectacular finishes.", mls_id: "MLS-4404" }
  ] },
  { client: 2, name: "Capitol Hill Singles", date: "2026-06-12", time: "3:00 PM", status: "confirmed", post_notes: "", properties: [
    { address: "1250 N Pennsylvania St #3A", city: "Denver, CO 80203", beds: 1, baths: 1, price: "$299,000", notes: "Great starter. Walk to everything.", mls_id: "MLS-7701" },
    { address: "890 N Logan St #8", city: "Denver, CO 80203", beds: 2, baths: 1, price: "$334,000", notes: "Top floor, city views.", mls_id: "MLS-7702" },
    { address: "1100 Ogden St #2B", city: "Denver, CO 80218", beds: 1, baths: 1, price: "$285,000", notes: "", mls_id: "MLS-7703" }
  ] },
  { client: 1, name: "Stapleton Family Homes", date: "2026-06-14", time: "9:00 AM", status: "draft", post_notes: "", properties: [
    { address: "7892 E 50th Ave", city: "Denver, CO 80238", beds: 4, baths: 3, price: "$575,000", notes: "Close to Central Park.", mls_id: "MLS-9901" },
    { address: "5130 Uinta St", city: "Denver, CO 80238", beds: 5, baths: 4, price: "$648,000", notes: "Model home condition.", mls_id: "MLS-9902" }
  ] },
  { client: 2, name: "Cherry Creek Showings", date: "2026-06-17", time: "1:00 PM", status: "confirmed", post_notes: "", properties: [
    { address: "2 Garfield St #401", city: "Denver, CO 80206", beds: 2, baths: 2, price: "$895,000", notes: "Penthouse. Two parking spots.", mls_id: "MLS-3301" },
    { address: "300 Clayton St #12", city: "Denver, CO 80206", beds: 3, baths: 2, price: "$1,050,000", notes: "Slightly over budget.", mls_id: "MLS-3302" },
    { address: "155 S Madison St", city: "Denver, CO 80209", beds: 3, baths: 3, price: "$980,000", notes: "Townhome, no HOA. Rooftop deck.", mls_id: "MLS-3303" }
  ] },
  { client: 3, name: "RiNo District Tour", date: "2026-05-29", time: "10:00 AM", status: "confirmed", post_notes: "Amanda loved stop 1. Schedule second look.", properties: [
    { address: "3400 Larimer St #201", city: "Denver, CO 80205", beds: 2, baths: 2, price: "$465,000", notes: "Live/work loft. Exposed brick.", mls_id: "MLS-8801" },
    { address: "2900 Walnut St #5B", city: "Denver, CO 80205", beds: 2, baths: 1, price: "$429,000", notes: "Top floor, rooftop access.", mls_id: "MLS-8802" },
    { address: "3200 Blake St", city: "Denver, CO 80205", beds: 3, baths: 2, price: "$512,000", notes: "", mls_id: "MLS-8803" }
  ] },
  { client: 4, name: "Sloan's Lake Homes", date: "2026-05-27", time: "1:00 PM", status: "confirmed", post_notes: "Talia preferred stop 2. Marcus liked yard on stop 1.", properties: [
    { address: "1720 N Zenobia St", city: "Denver, CO 80204", beds: 4, baths: 3, price: "$745,000", notes: "Two blocks from the lake.", mls_id: "MLS-6601" },
    { address: "2015 N Vrain St", city: "Denver, CO 80212", beds: 3, baths: 2, price: "$698,000", notes: "Corner lot, mountain views.", mls_id: "MLS-6602" }
  ] },
  { client: 5, name: "Baker Neighborhood Tour", date: "2026-05-20", time: "10:00 AM", status: "completed", post_notes: "Derek ruled out stop 2 (roof). Interested in stop 1.", properties: [
    { address: "55 W Cedar Ave", city: "Denver, CO 80223", beds: 3, baths: 2, price: "$548,000", notes: "Classic bungalow. Great backyard.", mls_id: "MLS-1101" },
    { address: "180 S Pennsylvania St", city: "Denver, CO 80223", beds: 4, baths: 2, price: "$589,000", notes: "Needs new roof per inspection.", mls_id: "MLS-1102" },
    { address: "420 W Bayaud Ave", city: "Denver, CO 80223", beds: 3, baths: 1, price: "$499,000", notes: "Original 1940s charm.", mls_id: "MLS-1103" }
  ] },
  { client: 6, name: "Congress Park Condos", date: "2026-05-15", time: "2:00 PM", status: "completed", post_notes: "Priya loved stop 1. Will likely offer.", properties: [
    { address: "1200 Fillmore St #3C", city: "Denver, CO 80206", beds: 2, baths: 2, price: "$415,000", notes: "Priya's favorite. Great light.", mls_id: "MLS-2201" },
    { address: "900 Albion St #7", city: "Denver, CO 80220", beds: 1, baths: 1, price: "$329,000", notes: "Below budget. Good backup.", mls_id: "MLS-2202" }
  ] },
  { client: 7, name: "Park Hill Showings", date: "2026-05-10", time: "11:00 AM", status: "completed", post_notes: "Tom and Lisa made offer on stop 1 same day.", properties: [
    { address: "2340 Dahlia St", city: "Denver, CO 80207", beds: 4, baths: 3, price: "$672,000", notes: "Top pick. Offer submitted.", mls_id: "MLS-3401" },
    { address: "3010 Forest St", city: "Denver, CO 80207", beds: 3, baths: 2, price: "$598,000", notes: "Backup option.", mls_id: "MLS-3402" },
    { address: "2800 Grape St", city: "Denver, CO 80207", beds: 4, baths: 2, price: "$641,000", notes: "Needs kitchen update.", mls_id: "MLS-3403" }
  ] },
  { client: 8, name: "Platt Park Singles", date: "2026-05-05", time: "3:00 PM", status: "completed", post_notes: "Stop 2 went under contract 2 days later.", properties: [
    { address: "1540 S Pearl St #2", city: "Denver, CO 80210", beds: 2, baths: 1, price: "$378,000", notes: "Brittany loved walkability.", mls_id: "MLS-4501" },
    { address: "1820 S Ogden St", city: "Denver, CO 80210", beds: 2, baths: 2, price: "$412,000", notes: "Newly renovated.", mls_id: "MLS-4502" }
  ] },
  { client: 9, name: "Green Valley Ranch", date: "2026-04-28", time: "9:00 AM", status: "completed", post_notes: "James and Keisha offered on stop 2.", properties: [
    { address: "4820 Dunkirk St", city: "Denver, CO 80249", beds: 5, baths: 4, price: "$562,000", notes: "Great for the family.", mls_id: "MLS-5601" },
    { address: "5100 Harvest Rd", city: "Denver, CO 80249", beds: 4, baths: 3, price: "$524,000", notes: "New build. Offer submitted.", mls_id: "MLS-5602" },
    { address: "4610 Lisbon St", city: "Denver, CO 80249", beds: 4, baths: 3, price: "$541,000", notes: "HOA covers landscaping.", mls_id: "MLS-5603" }
  ] }
]

tours = tours_data.map do |data|
  tour = agent.tours.create!(
    client: clients[data[:client] - 1],
    name: data[:name],
    tour_date: Date.parse(data[:date]),
    tour_time: data[:time],
    status: data[:status],
    post_notes: data[:post_notes]
  )
  data[:properties].each { |p| tour.properties.create!(p) }
  tour
end

# Message threads for the first two tours (agent + client).
[
  { tour: tours[0], from: "agent", body: "Hey Sarah and Mike! Tour confirmed June 3rd at 10am." },
  { tour: tours[0], from: "client", body: "Perfect! Really excited about Clarkson Ave." },
  { tour: tours[0], from: "agent", body: "Absolutely! Great updated kitchen there." },
  { tour: tours[1], from: "agent", body: "Jordan, Wash Park tour set for June 7th at 2pm. Works?" }
].each do |m|
  sender_id = m[:from] == "agent" ? agent.id : m[:tour].client_id
  m[:tour].messages.create!(sender_type: m[:from], sender_id: sender_id, body: m[:body])
end

puts "Done. Demo agent: janey@fatbirdmarketing.com / tourvi123"
puts "#{Client.count} clients, #{Tour.count} tours, #{Property.count} properties, #{Message.count} messages."
