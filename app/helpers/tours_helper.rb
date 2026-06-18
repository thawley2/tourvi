module ToursHelper
  # Simulated drive times (minutes) cycling through a fixed set, matching the
  # prototype. Replace with the Google Directions API later.
  DRIVE_TIMES = [ 8, 12, 6, 9, 14, 7, 11, 5 ].freeze

  def drive_time(index)
    DRIVE_TIMES[index % DRIVE_TIMES.size]
  end

  # Total drive time across the legs between an ordered list of stops.
  def total_drive_time(count)
    return 0 if count < 2

    (0...(count - 1)).sum { |i| drive_time(i) }
  end

  # Google Maps multi-stop route link (no API key required).
  def maps_route_url(properties)
    stops = properties.map { |p| CGI.escape(p.maps_query) }.join("/")
    "https://www.google.com/maps/dir/#{stops}"
  end

  # Google Calendar event link prefilled with the tour name, time, and stops.
  def google_calendar_url(tour)
    return nil if tour.tour_date.blank?

    start_at = tour_start_time(tour)
    finish_at = start_at + 2.hours
    fmt = "%Y%m%dT%H%M00"
    stops = tour.properties.each_with_index.map { |p, i| "Stop #{i + 1}: #{p.address}" }.join("\n")
    params = {
      action: "TEMPLATE",
      text: tour.name,
      dates: "#{start_at.strftime(fmt)}/#{finish_at.strftime(fmt)}",
      details: "Property Tour\n\n#{stops}",
      location: tour.properties.first&.address.to_s
    }
    "https://calendar.google.com/calendar/render?#{params.to_query}"
  end

  # Plain-text tour recap for email/SMS, mirroring the prototype.
  def recap_text(tour)
    client = tour.client
    ratings = client.ratings.where(property: tour.properties).index_by(&:property_id)
    stops = tour.properties.each_with_index.map do |p, i|
      emoji = ratings[p.id] ? " #{Rating::EMOJIS[ratings[p.id].value]}" : ""
      price = p.price.present? ? " — #{p.price}" : ""
      "#{i + 1}. #{p.address}, #{p.city}#{price}#{emoji}"
    end
    top_picks = tour.properties.select { |p| ratings[p.id]&.value == 3 }
    closing = tour.post_notes.presence || "Let me know if any stood out or you'd like a second look!"

    lines = []
    lines << "Hi #{client.name.split(" ").first},"
    lines << ""
    lines << "Great touring with you#{tour.tour_date ? " on #{format_tour_date(tour.tour_date)}" : ""}! Here's a quick recap:"
    lines << ""
    lines.concat(stops)
    if top_picks.any?
      lines << ""
      lines << "Top pick#{"s" if top_picks.size > 1}: #{top_picks.map(&:address).join(", ")}"
    end
    lines << ""
    lines << closing
    lines << ""
    lines << "Talk soon,"
    lines << tour.agent.name
    lines.join("\n")
  end

  def mailto_link(email, subject, body)
    "mailto:#{email}?subject=#{ERB::Util.url_encode(subject)}&body=#{ERB::Util.url_encode(body)}"
  end

  def sms_link(phone, body)
    "sms:#{phone}?&body=#{ERB::Util.url_encode(body)}"
  end

  private

  def tour_start_time(tour)
    hour = 9
    minute = 0
    if tour.tour_time.present? && (m = tour.tour_time.match(/(\d+):(\d+)\s*(AM|PM)?/i))
      hour = m[1].to_i
      minute = m[2].to_i
      meridian = m[3]&.upcase
      hour += 12 if meridian == "PM" && hour != 12
      hour = 0 if meridian == "AM" && hour == 12
    end
    tour.tour_date.to_time.change(hour: hour, min: minute)
  end
end
