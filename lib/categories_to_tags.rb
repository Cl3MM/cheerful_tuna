#!/usr/bin/env ruby
#encoding: utf-8

require 'open-uri'
require 'matrix'
require 'awesome_print'

class CategoriesToTags

  @@raw_matrix_file = "#{Rails.root}/tmp/testtest.csv"
  @@raw_matrix = open(@@raw_matrix_file).read


  @@categories = ["Consulting",
                  "ENF Sellers",
                  "PV industrie",
                  "Renewable Energy Associations",
                  "Solarthermie, Photovoltaik",
                  "Photovoltaik",
                  "Renewables & Environment",
                  "Sellers",
                  "sellers",
                  "Seller, Solarthermie, Photovoltaik",
                  "Otros",
                  "Montaje de sistemas fotovoltaicos",
                  "Fabricacion de otros componentes",
                  "Distribucion de componentes de sistemas fotovoltaicos",
                  "Produccion de energia electrica",
                  "Distribucion de componentes de",
                  "Fabricacion de modulos",
                  "Solar System Installers",
                  "thermie, Photovoltaik",
                  "Fabricacion de otros componentes especificos para",
                  "Chaudières bois",
                  "Fabricacion de otros componentes especificos para sistemas fotovoltaicos",
                  "Produccion de energia electricaFinanciacion",
                  "Produccion de energia electricaMontaje de sistemas",
                  "ENF Solar System Installers",
                  "Fabricacion de estructuras para el soporte de",
                  "Inter Solar",
                  "Montaje de sistemas fotovoltaicos",
                  "Fabricacion de inversores,Fabricacion de otros componentes especificos para",
                  "customer",
                  "Solar System Installer",
                  "System Installers",
                  "Architecte",
                  "France Exhibition",
                  "ENF installer",
                  "Installer",
                  "installer",
                  "Installers",
                  "HEINRICH",
                  "Manufacturer",
                  "seller",
                  "ENF Seller",
                  "ENF installers",
                  "ENF sellers",
                  "Belgique Installateurs",
                  "solar systerm installer",
                  "ENF Solar Panel",
                  "Distributeur/Revendeur",
                  "ter Solar",
                  "Inter Solar/BPVA",
                  "Inter Solar/ BPVA",
                  "Government dept",
                  "seller & installer",
                  "installers",
                  "Seller",
                  "installer/ apisolar",
                  "sellers & installers",
                  "BPVA",
                  "Exhibtion",
                  "Sénateur Français",
                  "ENF-Seller",
                  "ENR",
                  "SER_annuaire_industrie_PV_2011",
                  "Distributor",
                  "panel",
                  "Ensembliers Importateurs Distributeurs",
                  "Enerplan - Exploitants et developpeurs",
                  "energaia",
                  "Societe de service et installation",
                  "Enerplan-Bureaux",
                  "Government body",
                  "Press",
                  "Import and Export",
                  "Information Technology and Services",
                  "jpp",
                  "Environmental Services",
                  "Market Research",
                  "Oil & Energy",
                  "Capital Markets",
                  "Electrical/Electronic Manufacturing",
                  "Public Relations and Communications",
                  "Construction",
                  "Transportation/Trucking/Railroad",
                  "Financial Services",
                  "International Trade and Development",
                  "Mechanical or Industrial Engineering",
                  "Design",
                  "Civil Engineering",
                  "Polysilicon",
                  "Material and Components",
                  "Management Consulting",
                  "Education Management",
                  "Building Materials",
                  "Business Supplies and Equipment",
                  "Marketing and Advertising",
                  "ENF  installer",
                  "Solar Energy Society",
                  "Wholesale",
                  "Renewables & Environment/BPVA",
                  "apisolar",
                  "Collection Point",
                  "Participant" ]


  @@tags = [ "PV manufacturer",
             "Cell manufacturer",
             "Material and components manufacturer",
             "Mounting systems manufacturer",
             "Production equipment manufacturer",
             "Inverter manufacturer",
             "Importer",
             "National solar associations",
             "Apisolar",
             "Other associations",
             "SER",
             "Enerplan",
             "Energaia",
             "Research organizations",
             "Retailers & resellers",
             "Distributor",
             "Solar system installers",
             "System integrators",
             "Project developers",
             "Energy plant operator",
             "Electrical installation contractor",
             "Exhibition & Conference",
             "End-user",
             "Market Research",
             "Environmental Services",
             "Waste management",
             "Architects",
             "Energy suppliers & utilities",
             "Governmental organizations",
             "Financial services",
             "Educational institutions",
             "Insurances",
             "Consultancy firms",
             "Press & Medias",
             "Sénat",
             "Enerplan",
             "SER",
             "EPIA",
             "PVCYCLE",
             "BPVA",
             "Solar termal manufacturers",
             "power plant operator",
             "Intersolar 2012",
             "Information Technology and Services",
             "Construction"]

  attr_accessor :tags_categories_hash, :categories_tags_hash 

  def initialize
    @matrix = Matrix.rows @@raw_matrix.lines.map { |l| l.split(",").map(&:to_i) }
    @tags_categories_hash = tags_categories
    @categories_tags_hash = categories_tags
  end

  def tags_categories
    hash = {}
    @matrix.each_with_index do |e, row, col|
      if e == 1
        if hash.has_key? @@categories[row]
          hash[@@categories[row]] << @@tags[col]
        else
          hash[@@categories[row]] = [ @@tags[col] ]
        end
      end
    end
    hash
  end

  def categories_tags
    hash = {}
    @matrix.each_with_index do |e, row, col|
      if e == 1
        if hash.has_key? @@tags[col]
          hash[@@tags[col]] << @@categories[row]
        else
          hash[@@tags[col]] = [ @@categories[row] ]
        end
      end
    end
    hash
  end

end
