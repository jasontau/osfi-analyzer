# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

path = "app/data/"

# helpers
def fast_insert(insert_model, column, values)
  values -= insert_model.pluck(column)
  insert_values = values.map{|value| "(#{value})"}.join(",")
  return if insert_values.empty?
  sql = "INSERT INTO #{insert_model.table_name} (#{column}) VALUES #{insert_values}"
  ActiveRecord::Base.connection.execute(sql)
end

def fast_insert_multiple(insert_model, unique_column, values)
  conn = ActiveRecord::Base.connection
  existing_values = insert_model.pluck(unique_column)
  columns = values.first.map{ |k,v| k.to_s }.join(",")
  values.delete_if{ |item| existing_values.include?(item[unique_column.to_sym]) }
  values.map{ |item| "(#{item.map{ |k,v| conn.quote(v) }.join(',')})" }.join(",")
  insert_values = values.map{ |item| "(#{item.map{ |k,v| conn.quote(v) }.join(',')})" }.join(",")
  return if insert_values.empty?
  sql = "INSERT INTO #{insert_model.table_name} (#{columns}) VALUES #{insert_values}"
  conn.execute(sql)
end

def fast_insert_data(values)
  conn = ActiveRecord::Base.connection
  insert_model = Datum
  insert_model.delete_all
  columns = values.first.map{ |k,v| k.to_s }.join(",")
  values.map{ |item| "(#{item.map{ |k,v| conn.quote(v) }.join(',')})" }.join(",")
  insert_values = values.map{ |item| "(#{item.map{ |k,v| conn.quote(v) }.join(',')})" }.join(",")
  return if insert_values.empty?
  sql = "INSERT INTO #{insert_model.table_name} (#{columns}) VALUES #{insert_values}"
  ActiveRecord::Base.connection.execute(sql)
  # p sql
end

def create_lookup_hash(model, lookup_column )
  result = Hash.new
  model.pluck(lookup_column, :id).each{ |k,v| result[k]=v }
  return result
end

# static data definitions
years = ("10".."18").to_a
quarters = ("1".."4").to_a
statements = [
  { name: "Canadian P&C Companies", code: "10" },
  { name: "Foreign P&C Companies", code: "20" },
]
pages = [
  { code: "6020", name: "Consolidated Premiums and Claims" },
  { code: "6021", name: "Claims Incurred - Discounted" },
  { code: "6030", name: "Claims and Adjustment Expenses - Paid, Current Year and Unpaid, Current and Prior Year" },
]

# parse data from files
# companies
companies = []
years.each { |year|
  filename = "#{path}20#{year} P&C Companies.csv"
  if File.exist?(filename) then
    count = %x{wc -l '#{filename}'}.split.first.to_i
    p "#{filename} company records found: " + count.to_s
    CSV.foreach(filename, :headers => true, encoding:'iso-8859-1:utf-8') { |row|
      companies.push({ code: row.field('Code'), name: row.field('Company') })
    }
  end
}

# database insertions
fast_insert(Year, "year", years)
fast_insert(Quarter, "quarter", quarters)
fast_insert_multiple(Statement, "code", statements)
fast_insert_multiple(Company, "code", companies)
fast_insert_multiple(Page, "code", pages)

# build data hashes
hash_years = create_lookup_hash(Year, :year)
hash_quarters = create_lookup_hash(Quarter, :quarter)
hash_statements = create_lookup_hash(Statement, :code)
hash_companies = create_lookup_hash(Company, :code)
hash_pages = create_lookup_hash(Page, :code)

# parse financial data
# TODO: set up and parse data for all pages, currently only using data for:
# 60.20, 60.21, 60.30

slice_map = [2,2,1,4,4,2,2,16]
schema = [
  {statement_id: hash_statements},
  {year_id: hash_years},
  {quarter_id: hash_quarters},
  {company_id: hash_companies},
  {page_id: hash_pages},
  {row_index: ''},
  {column_index: ''},
  {amount: ''}
]

def parse_data_line(line, slice_map)
  count = 0
  result = []
  slice_map.each { |value|
    result << line.slice(count, value)
    count += value
  }
  return result
end

def format_data_line(line, schema)
  result = Hash.new
  schema.each_with_index { |schem,index|
    line_value = line[index]
    schema_hash = schem.first[1]
    schema_key = schem.first[0]

    lookup = schema_hash[line_value] || line_value
    if schema_key == :value then
      lookup = lookup.to_d
    elsif schema_key == :row || schema_key == :column then
      lookup = lookup.to_i
    end

    result[schema_key] = lookup
  }
  return result
end

restricted_pages = Page.pluck(:code)

data_lines = []
total_records_searched = 0

Year.pluck(:year).each { |year|
  Quarter.pluck(:quarter).each { |quarter| 
    Statement.pluck(:code).each { |statement|
      statement = statement.slice(0)
      filename = "#{path}20#{year}#{quarter}-#{statement}-pc.txt"
      if File.exist?(filename) then
        count = %x{wc -l '#{filename}'}.split.first.to_i
        p "#{filename} data records found: " + count.to_s
        total_records_searched += count
        File.open(filename).each do |line|
          # only parse lines for set up pages right now
          page = line.slice(9,4)
          if restricted_pages.include?(page) then
            parsed = parse_data_line(line, slice_map)
            formatted = format_data_line(parsed, schema)
            data_lines << formatted
            break
          end
        end
      end
    }
  }
}

p "TOTAL PARSED DATA LINES: #{data_lines.count} / #{total_records_searched}"
p data_lines

fast_insert_data(data_lines)