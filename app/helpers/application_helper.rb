module ApplicationHelper
  # Tailwind classes for a tour status pill. Past tours render as "completed".
  STATUS_BADGE = {
    "confirmed" => "bg-[#E6F4EA] text-[#1A7F37]",
    "draft" => "bg-[#FFF3CD] text-[#856404]",
    "completed" => "bg-[#E8E8E8] text-[#555555]"
  }.freeze

  STATUS_DOT = {
    "confirmed" => "bg-[#2DA44E]",
    "draft" => "bg-[#FFC107]",
    "completed" => "bg-[#999999]"
  }.freeze

  AVATAR_PALETTE = %w[#C9A96E #7B9E87 #8B7BAE #C97B6E #6E8EC9 #7BA8C9 #9E7B9E #C9A07B #7BC9A0 #A0C97B].freeze

  # Literal Tailwind arbitrary-color classes so the build scanner generates them
  # (interpolated class strings are NOT detected by Tailwind).
  AVATAR_BG = {
    "#C9A96E" => "bg-[#C9A96E]", "#7B9E87" => "bg-[#7B9E87]", "#8B7BAE" => "bg-[#8B7BAE]",
    "#C97B6E" => "bg-[#C97B6E]", "#6E8EC9" => "bg-[#6E8EC9]", "#7BA8C9" => "bg-[#7BA8C9]",
    "#9E7B9E" => "bg-[#9E7B9E]", "#C9A07B" => "bg-[#C9A07B]", "#7BC9A0" => "bg-[#7BC9A0]",
    "#A0C97B" => "bg-[#A0C97B]", "#1A1A18" => "bg-[#1A1A18]"
  }.freeze

  AVATAR_SIZE = {
    xs: "w-5 h-5 text-[9px]",
    sm: "w-6 h-6 text-[10px]",
    md: "w-9 h-9 text-xs",
    lg: "w-14 h-14 text-xl"
  }.freeze

  STATUS_BORDER = {
    "confirmed" => "border-[#2DA44E]",
    "draft" => "border-[#FFC107]",
    "completed" => "border-[#999999]"
  }.freeze

  def status_dot_border(status)
    STATUS_BORDER.fetch(status.to_s, STATUS_BORDER["draft"])
  end

  def status_badge(status)
    status = status.to_s
    classes = STATUS_BADGE.fetch(status, STATUS_BADGE["draft"])
    dot = STATUS_DOT.fetch(status, STATUS_DOT["draft"])
    content_tag :span, class: "inline-flex items-center gap-1.5 rounded-full px-2 py-0.5 text-xs font-semibold #{classes}" do
      concat content_tag(:span, "", class: "h-1.5 w-1.5 rounded-full #{dot}")
      concat status
    end
  end

  # Color-block avatar with initials, matching the prototype style.
  def avatar(name, color: nil, size: :md, idx: 0)
    bg = AVATAR_BG[color&.upcase] || AVATAR_BG[AVATAR_PALETTE[idx % AVATAR_PALETTE.size]]
    initials = name.to_s.split(/\s+/).filter_map { |w| w[0] }.first(2).join.upcase
    content_tag :span, initials,
      class: "inline-flex shrink-0 items-center justify-center rounded-full font-bold text-white #{AVATAR_SIZE.fetch(size)} #{bg}"
  end

  STAGE_BADGE = {
    "Searching" => "bg-[#E8E8E8] text-[#555555]",
    "Touring" => "bg-[#FFF3CD] text-[#856404]",
    "Under Contract" => "bg-[#E6EEF8] text-[#2152A8]",
    "Closed" => "bg-[#E6F4EA] text-[#1A7F37]"
  }.freeze

  def stage_badge(stage)
    classes = STAGE_BADGE.fetch(stage.to_s, STAGE_BADGE["Searching"])
    content_tag :span, stage, class: "inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-semibold #{classes}"
  end

  SUGGESTION_BADGE = {
    "pending" => "bg-[#FFF3CD] text-[#856404]",
    "approved" => "bg-[#E6F4EA] text-[#1A7F37]",
    "declined" => "bg-[#FEE2E2] text-[#DC2626]"
  }.freeze

  def suggestion_status_badge(status)
    classes = SUGGESTION_BADGE.fetch(status.to_s, SUGGESTION_BADGE["pending"])
    content_tag :span, status, class: "rounded-full px-2 py-0.5 text-[11px] font-semibold #{classes}"
  end

  def nav_link_classes(active)
    base = "rounded-md px-3 py-1.5 text-[13px] font-medium"
    active ? "#{base} bg-white/10 text-gold" : "#{base} text-[#aaaaaa] hover:text-white"
  end

  AVATAR_PX = { xs: 20, sm: 24, md: 36, lg: 56 }.freeze

  # Renders the agent's uploaded avatar if present, otherwise the initials block.
  def agent_avatar(agent, size: :md)
    if agent.avatar.attached?
      px = AVATAR_PX.fetch(size)
      image_tag agent.avatar.variant(resize_to_fill: [ px, px ]),
        class: "shrink-0 rounded-full object-cover #{AVATAR_SIZE.fetch(size).split.first(2).join(" ")}"
    else
      avatar(agent.name, color: agent.profile_color, size: size)
    end
  end

  def format_tour_date(date)
    return "" if date.blank?

    date.strftime("%b %-d, %Y")
  end
end
