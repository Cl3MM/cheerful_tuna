#encoding: utf-8
#
class InvoicePdf < Prawn::Document
  def initialize(invoice, specimen = false)
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

    @ceres = "CERES - Centre Européen pour le Recyclage des Équipements Solaire"
    @address = "CERES\n96 rue Raymond Losserand\n75014 Paris\nFrance\nTel: +33 970 444 458\nSIRET: 539 167 122 00016"
    @payto = "96 rue Raymond Losserand\n75014 Paris, FRANCE"
    require "prawn/measurement_extensions"
    if invoice
      @invoice = invoice

      super(page_size: "A4",
            bottom_margin: 30,
            top_margin: 40,
            right_margin: 40,
            left_margin: 40,
            info: {
              Title: "CERES invoice for #{@invoice.designation.html_safe}",
              Author: @ceres,
              Keywords: "CERES invoice http://www.ceres-recycle.org",
              Creator: @ceres,
              Producer: "CERES Invoice Generator",
              CreationDate: Time.now.strftime('%a %b %e %H:%M:%S %Y'),
              CertifId: "#{@invoice.code.html_safe}",
              Subject: "CERES invoice ##{@invoice.code.html_safe} for #{@invoice.designation.html_safe}",
            }
           )
           encrypt_document :permissions => { modify_contents: false, copy_contents: false, print_document: true }, owner_password: :random
           background_repeat
           footer
           invoice_header
           pay_to
           invoice_items
           recipient
           remittance_route
           date_and_signature
           fake_specimen if @specimen
    else
      super(page_size: "A4",
            bottom_margin: 0,
            top_margin: 0,
            right_margin: 0,
            left_margin: 0)
      font @fonts[:MPB]
      text "Something went wrong, please contact CERES administrator", size: 52, align: :center
      fill_color "013ADF"
      font @fonts[:MPSB]
      text 350, "contact@ceres-recycle.org", size: 52, align: :center
    end
  end

  def invoice_header
    head = "#{Rails.root}/app/assets/images/CERES_480px.jpg"
    image head, :width => 145, at: [0,bounds.top]

    font @fonts[:MPB]
    bounding_box([210, bounds.top-10], :width => 306, :height => 100) do
      text I18n.t("invoices_pdf.invoice"), size: 46, align: :right
      text "#{I18n.t("invoices_pdf.date")} #{@invoice.updated_at.strftime(I18n.t("invoices_pdf.date_format"))}", size: 14, align: :right
      text "#{I18n.t("invoices_pdf.number")}#{@invoice.code.html_safe}", size: 14, align: :right
      #transparent(0.5) { stroke_bounds }
    end
  end

  def pay_to
    font @fonts[:MPB]
    bounding_box([0, 630], :width => 258, :height => 120) do
      transparent(0.5) { stroke_bounds }
    end
    gap = 5
    bounding_box([258, 630], :width => 258, :height => 120) do
      bounding_box([gap, (bounds.top - gap) ] , :width => (250 - gap * 2) ) do
        text @ceres, size: 11, align: :justify
        font @fonts[:MPR]
        move_down 5
        text @address, size: 11, align: :justify
      end
      transparent(0.5) { stroke_bounds }
    end
  end

  def invoice_items
    font "Helvetica"
    move_down 30
    table([
      [{ content: "<b>#{I18n.t("invoices_pdf.description")}</b>", width: 326 },
       { content: "<b>#{I18n.t("invoices_pdf.quantity")}</b>",    width: 50},
       { content: "<b>#{I18n.t("invoices_pdf.unit_price")}</b>",  width: 70},
       { content: "<b>#{I18n.t("invoices_pdf.price")}</b>",       width: 70}]
    ], width: 516, cell_style: { size: 11, inline_format: true, font: "Helvetica", padding: [3,3,3,3], align: :center, background_color: "DDDDDD" } )

    table(@invoice.line_items.map do | item |
      [{ content: "#{item.designation}",          width: 326 },
       { content: "#{item.amount}",               width: 50, valign: :center, align: :center },
       { content: "#{"%.2f" % item.unit_price}",  width: 70, valign: :center, align: :center },
       { content: "#{"%.2f" % item.total_price}", width: 70, valign: :center, align: :center }
    ]
    end, width: 516, cell_style: { size: 11, inline_format: true, font: "Helvetica", padding: [4,4] })

    table([
      [ { content: "<b>#{I18n.t("invoices_pdf.total_price")}</b>",  width: 446, align: :right  },
        { content: "<b>#{"%.2f" % @invoice.total_price}</b>",       width: 70,  align: :center }]
    ], width: 516, cell_style: { size: 11, inline_format: true, font: "Helvetica", background_color: "DDDDDD", padding: [3,5,3,3] } )
  end
  def recipient
    move_down 30
    y = cursor
    bounding_box([320, y], :width => 196) do
      font( @fonts[:MPR], size: 11 ) do
        text "<u>#{I18n.t("invoices_pdf.terms_of_payment")}</u>", inline_format: true
        move_down 11
        text I18n.t("invoices_pdf.terms")
      end
    end
    bounding_box([0, y], :width => 320 ) do
      font( @fonts[:MPR], size: 11 ) do
        text "<u>#{I18n.t("invoices_pdf.please_pay_to")}</u>", inline_format: true
        move_down 11
        text I18n.t("ceres")
        text @payto
      end
    end
  end

  def remittance_route
    font "Helvetica"
    move_down 30
    table([
      [{ content: "<b>#{I18n.t("invoices_pdf.remittance")}</b>",       width: 516}]
    ], width: 516, cell_style: { size: 11, inline_format: true, font: "Helvetica", padding: [3,3,3,3], align: :center, background_color: "DDDDDD" } )

    table( [
            [ { content: "#{I18n.t("invoices_pdf.beneficiary")}",     width: 156 },
              { content: "CAISSE D’EPARGNE ILE-DE-FRANCE",            width: 360, valign: :center, align: :center }
            ],
            [ { content: "#{I18n.t("invoices_pdf.account_number")}",  width: 156 },
              { content: "FR76 1751 5900 0008 0028 2383 742",         width: 360, valign: :center, align: :center }
            ],
            [ { content: "#{I18n.t("invoices_pdf.swift_code")}",      width: 156 },
              { content: "CEPAFRPP751",                               width: 360, valign: :center, align: :center }
            ],
          ], width: 516, cell_style: { size: 11, inline_format: true, font: "Helvetica", padding: [4,4]}
    )
  end

  def date_and_signature
    move_down 30
    y = cursor
    font @fonts[:MPSB], size: 11 do
      bounding_box([0, y], :width => 258 ) do
        text I18n.t("invoices_pdf.date_location"), align: :center
      end
      gap = 5
      bounding_box([258, y], :width => 258) do
        text I18n.t("invoices_pdf.signature"), align: :center
      end
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

  def background_repeat
    background = "#{Rails.root}/app/assets/images/CERES_LOGO_opacity_6.jpg"
    image background, width: 550, at: [-20,610]
  end

  def footer
    repeat :all do
      # header
      #bounding_box [bounds.left, bounds.top], :width  => bounds.width do
        #font "Helvetica"
        #text "Here's My Fancy Header", :align => :center, :size => 25
        #stroke_horizontal_rule
      #end

      # footer
      bounding_box [bounds.left, bounds.bottom + 25], :width  => bounds.width do
        fill_color "a0a0a0"
        font @fonts[:MPSB]

        transparent(0.25) {
          stroke_horizontal_rule
        }
        move_down(5)
        text "#{I18n.t("invoices_pdf.footer")}", :size => 8, align: :center
      end
    end
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
