#encoding: utf-8
#
class ContactPdf < Prawn::Document
  def initialize(contact, infos = ['address', 'phone', 'fax'])
    super(top_margin: 50)
    @contact = contact
    @infos = infos
    header
    display_contact_info
    footer
    stroke_axis height: 800
  end
end

def header
  #require 'prawn/fast_png'
  stroke_horizontal_rule
  move_down 10
  fond = "#{Rails.root}/app/assets/images/CERES_LOGO_opacity_20.jpg"
  image fond, width: 600, at: [-30,580]
  entete = "#{Rails.root}/app/assets/images/CERES_480px.jpg"
  image entete, :width => 140
  #image open("http://www.ceres-recycle.org/images/illustrations/ceres/CERES_LOGO.png")
  #draw_text @contact.company.upcase, size: 30, style: :bold, :at => [120,620]
  draw_text "Facture", size: 30, style: :bold, at: [340,645]
  draw_text "Date: #{Time.now.strftime("%d/%m/%Y")}", size: 15, at: [340,615]
  draw_text "N°: #{rand(16000..20000).to_s.rjust(16, " ")}", size: 15, at: [340,595]

  move_down 10
  stroke_horizontal_rule
end
def footer
  move_cursor_to 20
  txt = "Address: 96 rue Raymond Losserand, 75014 Paris, France | Tél: +33 970 444 458 | Fax:  +33 9 57 76 18 38 | Web : www.ceres-recycle.org"
  text txt, size: 8, align: :center #, character_spacing: 0.75
  move_down 2
  txt = "IBAN n° FR76 1751 5900 0008 0028 2383 742 | VAT n° FR91 539167122"
  text txt, size: 8, align: :center
end

def display_contact_info
  move_down 30
  arr = contact_info + email_info
  table arr do
    columns(0).font_style = :bold
    columns(0..1).align = :right
    columns(1).align = :left
    #self.row_colors = ["DDDDDD", "FFFFFF"]
    #self.header = true
  end
end

def contact_info
  @contact.attribute_names.map{|attr| [attr.capitalize, @contact[attr]] if @infos.include?(attr) }.compact
end

def email_info
  count = 1
  if @contact.emails.size > 1
    @contact.emails.map do |mail|
      count += 1
      ["Email ##{count}", mail.address]
    end
  else
    [["Email", @contact.emails.first.address]]
  end
end

def stroke_axis(options={})
  options = { :height => (cursor - 20).to_i,
              :width => bounds.width.to_i
  }.merge(options)

  dash(1, :space => 4)
  stroke_horizontal_line(-21, options[:width], :at => 0)
  stroke_vertical_line(-21, options[:height], :at => 0)
  undash

  fill_circle [0, 0], 1

  (100..options[:width]).step(100) do |point|
    fill_circle [point, 0], 1
    draw_text point, :at => [point-5, -10], :size => 7
  end

  (100..options[:height]).step(100) do |point|
    fill_circle [0, point], 1
    draw_text point, :at => [-17, point-2], :size => 7
  end
end
