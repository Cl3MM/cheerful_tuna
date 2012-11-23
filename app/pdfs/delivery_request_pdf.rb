#encoding: utf-8

module DRFVersion
  VERSION="1.1_EN"
end

class DeliveryRequestPdf < Prawn::Document
  include DRFVersion
  def initialize(delivery_request)
    @version = "DRF_#{DRFVersion::VERSION}"

    @delivery_attributes = ["Contact Details", :name, :company, :email, :telephone,:address, [:postal_code, :city], :country,
                            "Technical Details", :manufacturers, :technology, [:module_count, :pallets_number],
                            "Packaging", [:length, :width], [:height, :weight], :reason_of_disposal, :modules_condition,
                            "Administration" ]
    @specimen = nil
    @fonts = { UB:    "#{Rails.root}/app/assets/fonts/Ubuntu-B.ttf",
               UR:    "#{Rails.root}/app/assets/fonts/Ubuntu-R.ttf",
               UM:    "#{Rails.root}/app/assets/fonts/Ubuntu-M.ttf",
               DS:    "#{Rails.root}/app/assets/fonts/DroidSans.ttf",
               MPR:   "#{Rails.root}/app/assets/fonts/MyriadPro-Regular.ttf",
               MPB:   "#{Rails.root}/app/assets/fonts/MyriadPro-Bold.ttf",
               MPSB:  "#{Rails.root}/app/assets/fonts/MyriadPro-Semibold.ttf",
               AR:    "#{Rails.root}/app/assets/fonts/ARIALUNI.TTF"
    }
    require "prawn/measurement_extensions"
    @delivery_request = delivery_request

    #filename = "#{Rails.root}/app/assets/fonts/DeliveryRequestship_Certificate.pdf"
    super(page_size: "A4",
          bottom_margin: 0,
          top_margin: 0,
          right_margin: 0,
          left_margin: 0,
          info: {
            Title: "",
            Author: "",
            Keywords: "",
            Creator: "",
            Producer: "",
            CreationDate: Time.now.strftime('%a %b %e %H:%M:%S %Y'),
            CertifId: "#{@delivery_request.id.to_s.html_safe}",
            Subject: "",
          }
         )
         #encrypt_document :permissions => { modify_contents: false, copy_contents: false, print_document: true }, owner_password: :random
         images
         display_document_version
         display_delivery
         header
         #left_side
         #body
         #display_company
         #stroke_axis height: 900
         new_footer
         #fake_specimen if @specimen
  end

  def display_document_version
    text @version
  end
  def header
    font @fonts[:MPR]
    bounding_text 810, "Delivery Request Form (DRF)", size: 24, shift_left: 30, align: :center, leading: 0, shift: 0, height: 50, width: 400
    text = "To be completed in 2 copies, one for the customer and one for the certified Collection Point, and presented by the customer at the delivery"
    font @fonts[:MPR], style: :italic
    bounding_text 770, text, size: 12, shift_left: 42, align: :center, leading: 0, shift: 0, height: 50, width: 400
  end
  def fake_specimen
    fill_color "444444"
    font @fonts[:MPSB]
    draw_text "SPECIMEN", size: 180, at: [130,30], rotate: 58, rotate_around: :upper_left
    fill_color "ffffff"
    fill_rectangle [300, 220], 110, 103
    fill_rectangle [300, 118], 7, 5
  end
  def collection
    move_down 20
    table(
      [[{content: "<b>To be completed by the Certified Collection Point</b>", align: :center,
        colspan: 3, background_color: "0404B4", size: 11, text_color: "FFFFFF", inline_format: true, padding: [3,3,3,3] } ]],
        width: 500, position: :center)
    table([
      [{content: "<b>Collection Point ID Code</b>" },
       "", {content: "<b>Signature</b>", rowspan: 6 }],
       [{content: "<b>Decision</b>", rowspan: 2, valign: :center}, "<b>Acceptance</b>"],
       ["<b>Reject</b>"],
       ["<b>Recieved by (Name)</b>", ""],
       ["<b>Date of Acceptance</b>", ""],
       ["<b>Internal Delivery #</b>", ""]
    ], width: 500, position: :center, cell_style: { size: 11, background_color: "D8CEF6", inline_format: true, padding: [3,3,3,3] })

  end
  def display_delivery
    float do
      move_down 120
      table(
        @delivery_attributes.map do |a|
          if a.is_a? Array # 4 columns
            [{ content: "<b>#{a.first.to_s.humanize}</b>" },
             { content: @delivery_request[a.first].to_s.html_safe, align: :center },
             { content: "<b>#{a.last.to_s.humanize}</b>", align: :center },
             { content: @delivery_request[a.last].to_s.html_safe, align: :center }]
          elsif a.is_a? String # One title column
            [{ content: "<b>#{a}</b>", align: :center, colspan: 4, background_color: "0404B4", text_color: "FFFFFF" }]
          else # 2 columns
            a = "-" if a.blank?
            content = ( @delivery_request[a].to_s.blank? ? "-" : @delivery_request[a].to_s.html_safe.humanize )
            [{ content: "<b>#{a.to_s.humanize}</b>" },
             { content: content, colspan: 3, align: :center }]
          end
        end.tap do |a|
          # Tapping into @delivery_attributes to add more columns (date, signature...
          cell = make_cell content: "<b>Signature</b>", height: 50, valign: :center
          a.concat( [ [{ content: "<b>Date</b>" }, {content: "#{@delivery_request.created_at.strftime("%B %d, %Y") }", align: :center, colspan:3 }],
                      [cell, {content: "", colspan:3 }]
                    ])
        end, width: 500, position: :center, cell_style: { overflow: :shrink_to_fit, size: 11, inline_format: true, padding: [3,3,3,3] })
        collection
    end
  end

  def left_side
    # images
    fill_color "41AD49"
    fill_rectangle [0, 900], 105, 950
    font @fonts[:MPR]
    fill_color "ffffff"
    txt = "Certificat • Сертификат • Zertificat •" + " " * 12 + "• Certificate"
    draw_text txt, size: 36, at: [66,30], rotate: 90, rotate_around: :upper_left
    font @fonts[:AR]
    txt = "证书"
    draw_text txt, size: 36, at: [66,565], rotate: 90, rotate_around: :upper_left
    fill_color "000000"
  end

  # Stroke a shifted box around text at a given height in the page
  def bounding_text page_height = 0, txt = "I'm here. "*10, options = {}.symbolize_keys!
    options = { size: 12,
                align: :justify,
                leading: 0,
                strike: false,
                shift: 0,
                width: 594,
                overflow: :shrink_to_fit,
                shift_left: 105
    }.merge(options)

    shift = options[:shift] + options[:shift_left]
    width = options[:width] - options[:shift_left] - (options[:shift] * 2)

    box_height = options[:height] || (height_of(txt, size: options[:size], align: options[:align], leading: options[:leading])+20)
    move_cursor_to bounds.height

    bounding_box([shift,page_height], :width => width, height: box_height) do
      stroke_bounds if options[:strike]
      #  text txt, size: options[:size], align: options[:align], leading: options[:leading]
    end
    text_box txt, :at => [shift,page_height], size: options[:size], align: options[:align], leading: options[:leading],
      width: width, height: box_height,
      :overflow => options[:overflow]
  end

  def images
    head = "#{Rails.root}/app/assets/images/CERES_480px.jpg"
    image head, :width => 145, at: [409,845]
    background = "#{Rails.root}/app/assets/images/CERES_LOGO_opacity_8.5.jpg"
    #background = "#{Rails.root}/app/assets/images/CERES_LOGO_opacity_20.jpg"
    image background, width: 500, at: [50,650]
  end

  def body
    opts = [
      {
        font:  @fonts[:MPB], height: 685,
        text: "CERTIFICATE",
        options: {size: 50, :leading => 5, align: :center }
      },
      {
        #font:  @fonts[:MPR], height: 596,
        font:  @fonts[:MPR], height: 620,
        text: "We hereby certify that based upon the current commitment",
        options: {size: 18, :leading => 5, shift: 10, align: :center }
      },
      {
        font:  @fonts[:MPB], height: 343,
        text: "is a member of CERES, which organizes for its members the collection and recycling of end-of-life photovoltaic modules at the European level.",
        options: {size: 21, :leading => 0, shift: 18}
      },
      {
        font:  @fonts[:MPSB], height: 117,
        text: "Jean-Pierre Palier",
        options: {size: 11, :leading => 5, shift: 10, align: :center }
      },
      {
        font:  @fonts[:MPSB], height: 103,
        text: "President",
        options: {size: 11, :leading => 5, shift: 10, align: :center }
      }
    ]

    opts.each do |item|
      font item[:font]
      bounding_text item[:height], item[:text], item[:options]
    end
  end

  def display_company
    if @delivery_request.company =~ /ZHEJIANG TIANMING SOLAR/
      font @fonts[:MPB]
      bounding_text 590, "Zhejiang Tianming\nSolar Technology\nCo. Ltd.", size: 46, align: :center, leading: 0, shift: 20, height: 50, overflow: :expand
      font @fonts[:MPR]
      bounding_text 425, "311215, Xiaoshan, Hangzhou,\nZhejiang, CHINA", size: 28, align: :center, leading: 5#, overflow: :expand
    else
      font @fonts[:MPB]
      bounding_text 540, @delivery_request.company.html_safe.titleize, size: 52, align: :center, leading: 0, shift: 20, height: 50
      font @fonts[:MPR]
      bounding_text 468, "#{@delivery_request.postal_code.html_safe}, #{@delivery_request.city.html_safe.titleize}\n#{@delivery_request.country.html_safe.capitalize}", size: 28, align: :center, leading: 5
    end

    end_date = (@delivery_request.start_date + 1.year).prev_month.end_of_month
    day   = end_date.strftime('%d').to_i.ordinalize
    month = end_date.strftime('%B')
    year  = end_date.strftime('%Y')
    bounding_text 243, "Certificate Expiry Date: #{month} #{day}, #{year}", size: 16, align: :center, leading: 0, shift:100

    unless @delivery_request.qr_code_path.nil?
      qr_code = @delivery_request.qr_code_path
      image qr_code, at: [525,78], :width => 50
    end
  end

  def new_footer
    fill_color "a0a0a0"
    font @fonts[:MPSB]
    address = "CERES • 96 rue Losserand • 75014 Paris • France • www.ceres-recycle.org"
    bounding_text 25, address, size: 9.5, :leading => 5, shift: 0, align: :center, width:524
  end

  def stroke_axis(options={})
    options = { :height => (cursor - 20).to_i,
                :width => bounds.width.to_i,
    }.merge(options)

    shift = 150
    stroke_horizontal_line(-21, options[:width], :at => shift)
    stroke_vertical_line(-21, options[:height], :at => shift)
    undash

    legend_x = (shift > 0 ? shift - 15 : shift + 15)
    legend_y = (shift > 0 ? shift - 25 : shift + 15)

    fill_circle [0, 0], 1

    (100..options[:width]).step(100) do |point|
      fill_circle [point, shift], 1
      draw_text point, :at => [point-5, legend_x], :size => 7
    end

    (100..options[:height]).step(20) do |point|
      fill_circle [shift, point], 1
      draw_text point, :at => [ legend_y, point-2], :size => 7
    end
  end
end
