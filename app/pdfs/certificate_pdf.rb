#encoding: utf-8
#
class CertificatePdf < Prawn::Document
  def initialize(member)
    @member = member
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

    filename = "#{Rails.root}/app/assets/fonts/Membership_Certificate.pdf"
    super(page_size: "A4",
          bottom_margin: 0,
          top_margin: 0,
          right_margin: 0,
          left_margin: 0,
          info: {
            Title: "CERES Membership Certificate for #{@member.company} ",
            Author: "CERES - Centre Europeen pour le Recyclage de l'Energie Solaires",
            Keywords: "CERES Membership Certificate for #{@member.company} http://www.ceres-recycle.org",
            Creator: "CERES - Centre Europeen pour le Recyclage de l'Energie Solaires",
            Producer: "CERES Certificate Generator",
            CreationDate: Time.now.strftime('%d.%m.%Y::%H:%M:%S'),
            CertifId: "#{@member.object_id}",
            Subject: "This documents certify that #{@member.company}, #{@member.postal_code} \
#{@member.city.capitalize}, #{@member.country.upcase} is a member of CERES \
for the period #{@member.start_date.strftime('%B %d, %Y')} \
to #{(@member.start_date + 1.year).strftime('%B %d, %Y')}",
          }
         )
    #encrypt_document :permissions => { modify_contents: false, copy_contents: false, print_document: true }, owner_password: :random
    images
    left_side
    body
    company
    #stroke_axis height: 900
    new_footer
  end
end

def left_side
  # images
  fill_color "41AD49"
  fill_rectangle [0, 900], 105, 950
  font @fonts[:MPR]
  fill_color "ffffff"
  txt = "Certificat • Сертификат • Zertificat •" + " "*12 + "• Certificate"
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
              shift_left: 105
  }.merge(options)

  shift = options[:shift] + options[:shift_left]
  width = options[:width] - options[:shift_left] - (options[:shift] * 2)

  box_height = options[:height] || (height_of(txt, size: options[:size], align: options[:align], leading: options[:leading])+20)
  move_cursor_to bounds.height

  bounding_box([shift,page_height], :width => width, height: box_height) do
    stroke_bounds if options[:strike]
    text txt, size: options[:size], align: options[:align], leading: options[:leading]
  end
end

def images
  head = "#{Rails.root}/app/assets/images/CERES_480px.jpg"
  image head, :width => 145, at: [280,845]
  #background = "#{Rails.root}/app/assets/images/CERES_LOGO_opacity_20.jpg"
  #image background, width: 500, at: [100,650]
  signature = "#{Rails.root}/app/assets/images/Signature_JP_white_bg.jpg"
  image signature, width: 105, at: [300,220]
end

def body
  opts = [
    {
      font:  @fonts[:MPB], height: 685,
            text: "CERTIFICATE",
            options: {size: 59, :leading => 5, align: :center }
    },
    {
      font:  @fonts[:MPR], height: 596,
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

def company
  font @fonts[:MPB]
  bounding_text 516, @member.company, size: 48, align: :center, leading: 5

  font @fonts[:MPR]
  bounding_text 468, "#{@member.postal_code}, #{@member.city.capitalize}\n#{@member.country.capitalize}", size: 28, align: :center, leading: 5

  font @fonts[:MPR]
  end_date = @member.start_date + 1.year
  day   = end_date.strftime('%d').to_i.ordinalize
  month = end_date.strftime('%B')
  year  = end_date.strftime('%Y')
  bounding_text 243, "Certificate Expiry Date: #{month} #{day}, #{year}", size: 16, align: :center, leading: 5, shift:100

  qr_code = @member.qr_code_path
  image qr_code, :width => 75, at: [500,102]
end

def new_footer
  fill_color "a0a0a0"
  font @fonts[:MPSB]
  address = "CERES • 96 rue Losserand • 75014 Paris • France • www.ceres-recycle.org"
  bounding_text 35, address, size: 9.5, :leading => 5, shift: 0, align: :center, width:500
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
