#encoding: utf-8
#
class CertificatePdf < Prawn::Document
  def initialize(member, specimen = false)
    @specimen = specimen
    @fonts = { UB: "#{Rails.root}/app/assets/fonts/Ubuntu-B.ttf",
               UR: "#{Rails.root}/app/assets/fonts/Ubuntu-R.ttf",
               UM: "#{Rails.root}/app/assets/fonts/Ubuntu-M.ttf",
               DS: "#{Rails.root}/app/assets/fonts/DroidSans.ttf",
               MPR: "#{Rails.root}/app/assets/fonts/MyriadPro-Regular.ttf",
               MPB: "#{Rails.root}/app/assets/fonts/MyriadPro-Bold.ttf",
               MPSB: "#{Rails.root}/app/assets/fonts/MyriadPro-Semibold.ttf",
               AR: "#{Rails.root}/app/assets/fonts/ARIALUNI.TTF"
    }
    require "prawn/measurement_extensions"
    if member
      @member = member

      #filename = "#{Rails.root}/app/assets/fonts/Membership_Certificate.pdf"
      super(page_size: "A4",
            bottom_margin: 0,
            top_margin: 0,
            right_margin: 0,
            left_margin: 0,
            info: {
              Title: "CERES Membership Certificate for #{@member.company.html_safe}",
              Author: "CERES - Centre Europeen pour le Recyclage de l'Energie Solaire",
              Keywords: "CERES Membership Certificate #{@member.company.html_safe} http://www.ceres-recycle.org",
              Creator: "CERES - Centre Europeen pour le Recyclage de l'Energie Solaire",
              Producer: "CERES Certificate Generator",
              CreationDate: Time.now.strftime('%a %b %e %H:%M:%S %Y'),
              CertifId: "#{@member.id.to_s.html_safe}",
              Subject: "This documents certify that #{@member.company.html_safe}, #{@member.postal_code.to_s.html_safe} \
              #{@member.city.html_safe.capitalize}, #{@member.country.html_safe.upcase} is a member of CERES \
for the period #{@member.start_date.strftime('%B %d, %Y')} \
to #{(@member.start_date + 1.year).strftime('%B %d, %Y')}",
            }
           )
           encrypt_document :permissions => { modify_contents: false, copy_contents: false, print_document: true }, owner_password: :random
           images
           left_side
           body
           display_company
           #stroke_axis height: 900
           new_footer
           fake_specimen if @specimen
    else
      super(page_size: "A4",
            bottom_margin: 0,
            top_margin: 0,
            right_margin: 0,
            left_margin: 0)
      font @fonts[:MPB]
      bounding_text 580, "Something went wrong, please contact CERES administrator", size: 52, align: :center, leading: 0, shift: 0, shift_left: 0
      fill_color "013ADF"
      font @fonts[:MPSB]
      bounding_text 350, "contact@ceres-recycle.org", size: 52, align: :center, leading: 0, shift: 0, height: 50, shift_left: 0
    end
  end

  def fake_specimen
    fill_color "444444"
    font @fonts[:MPSB]
    draw_text "SPECIMEN", size: 180, at: [130,30], rotate: 58, rotate_around: :upper_left
    fill_color "ffffff"
    fill_rectangle [300, 220], 110, 103
    fill_rectangle [300, 118], 7, 5
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

  def images
    head = "#{Rails.root}/app/assets/images/CERES_480px.jpg"
    image head, :width => 145, at: [280,845]
    background = "#{Rails.root}/app/assets/images/CERES_LOGO_opacity_6.jpg"
    #background = "#{Rails.root}/app/assets/images/CERES_LOGO_opacity_20.jpg"
    image background, width: 500, at: [100,650]
    signature = "#{Rails.root}/app/assets/images/Signature_JP_white_bg.jpg"
    image signature, width: 105, at: [300,230]
  end

  def body
    opts = [
      {
        font:  @fonts[:MPB], height: 695,
        text: "CERTIFICATE",
        options: {size: 50, :leading => 5, align: :center }
      },
      {
        #font:  @fonts[:MPR], height: 596,
        font:  @fonts[:MPR], height: 630,
        text: "We hereby certify that based upon the current commitment",
        options: {size: 18, :leading => 5, shift: 10, align: :center }
      },
      {
        font:  @fonts[:MPB], height: 365,
        text: "is a member of CERES, which organizes for its members the collection and recycling of end-of-life photovoltaic modules at the European level.",
        options: {size: 21, :leading => 0, shift: 18}
      },
      {
        font:  @fonts[:MPSB], height: 115,
        text: "Jean-Pierre Palier",
        options: {size: 11, :leading => 5, shift: 10, align: :center }
      },
      {
        font:  @fonts[:MPSB], height: 100,
        text: "President",
        options: {size: 11, :leading => 5, shift: 10, align: :center }
      }
    ]

    opts.each do |item|
      font item[:font]
      bounding_text item[:height], item[:text], item[:options]
    end
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
                valign: :center,
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

  def display_company
    font @fonts[:MPB]

    bounding_box([115,590], width: 470, height: 90) do
      text @member.company.html_safe, size: 56, align: :center, valign: :center, overflow: :shrink_to_fit
    end
    font @fonts[:MPR]
    bounding_box([115,490], width: 470, height: 100) do
      text "#{@member.address.html_safe}\n#{@member.postal_code.html_safe}, #{@member.city.html_safe.titleize}\n#{@member.country.html_safe.capitalize}",
      size: 28, align: :center, valign: :center, overflow: :shrink_to_fit, leading: 5
    end

    bounding_box([115,270], width: 470, height: 30) do
      text "Certificate Expiry Date: #{@member.end_date_to_human}", size: 16, align: :center,
            valign: :center, overflow: :shrink_to_fit, leading: 5
    end

    if File.exists? @member.qr_code_path
      qr_code = @member.qr_code_path
      image qr_code, at: [525,78], :width => 50
    end
  end

  def new_footer
    fill_color "a0a0a0"
    font @fonts[:MPSB]
    address = "CERES • 96 rue Losserand • 75014 Paris • France • www.ceres-recycle.org"
    bounding_text 35, address, size: 9.5, :leading => 5, shift: 0, align: :center, width:524
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
