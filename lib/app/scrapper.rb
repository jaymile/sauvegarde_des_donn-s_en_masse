require 'json'
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pry'
require 'pp'



class Scrapper
attr_accessor :name
  def initialize name
    @name = name
  end


 def get_townhall_email
   email_town_hall = []
    doc = Nokogiri::HTML(open("http://annuaire-des-mairies.com/95/avernes.html"))
  doc.xpath('//tbody/tr[4]/td[2]').each do |v|
    email_town_hall = [v.text]
  end
    return email_town_hall
end



def get_townhall_urls
  doc = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))

  final = []
  doc.xpath("//tr[2]//p//a/@href").each do |v|
    final.push(v.text)
  end
  return  @result = final.map { |e| e.gsub('./' , 'http://annuaire-des-mairies.com/') }
end



 def url_email_methode #urls_des_mairies
   @email=[]
   n = get_townhall_urls.count
   i = 0
   while i < n
     doc = Nokogiri::HTML(open("#{get_townhall_urls[i]}"))
     doc.xpath('//section[2]/div/table/tbody/tr[4]/td[2]').map do |x|
       @email.push(x.text)
     end
     p @email[i]
        i += 1
   end
   return @email
end

  def save_as_JSON
    pretty = JSON.pretty_generate("#{@email}")
    File.open("../../../db/email.json","w") do |f|
    f.write(pretty.to_json)
    end
  end

  def perform
   url_email_methode
   get_townhall_urls
   get_townhall_email
   save_as_JSON
  end

end
test = Scrapper.new("wsh")
test.perform