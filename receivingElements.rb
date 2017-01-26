=begin
url = nil
puts 'Hello!'

while url == nil || url == '' do
  puts 'Please enter the URL of the website to the category, for the collection of all products from this category:'
  url = gets.to_s.chomp
end

puts 'URL with the category: ' + url
namefile = nil
while namefile == nil || namefile == '' do
  puts 'Please enter the name of the file in which the result will be recorded:'
  namefile = gets.to_s.chomp
end
namefile += '.csv'
puts 'Name of the file where the results will be recorded: ' +namefile
=end

require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'csv'
url = 'http://www.petsonic.com/es/perros/snacks-y-huesos-perro'
html = open(url)
page = Nokogiri::HTML(html)
products = []
counte = 0
page.xpath('//div[@class="productlist"]/div/div/div/div/div/a[@class="product_img_link"]/@href').each do |link|
  multiProductPage=Nokogiri::HTML(open(link))
  multiProductPage.xpath('//div[@class="container"]/div[@class="row"]/section[@id="center_column"]
/div[@class="primary_block"]/div[@class="row"]').each do |productlink|
    title = productlink.xpath('//div[@id="right"]/div[@class="pb-center-column"]
                                /div[@class=" col-xs-10"]/div[@class="product-name"]/h1/text()').text.strip
    pricelist =productlink.xpath('//div[@id="right"]/div[@class="pb-center-column"]
                                  /div[@class="box-center clearfix"]/form[@id="buy_block"]/div[@class="box-product-center"]
                                  /div[@class="product_attributes"]/div[@id="attributes"]/fieldset[@class="attribute_fieldset"]
                                  /div[@class="attribute_list"]/ul[@class="attribute_labels_lists"]/li')
    prices = []
    pricelist.xpath('//span[@class="attribute_price"]/text()').each do |price| prices.push(price.text.strip)
    end
    attnames = []
    pricelist.xpath('//span[@class="attribute_name"]/text()').each do |attname| attnames.push(attname)
    end
    img = productlink.xpath('//div[@id="left"]/div[@id="sidebar"]/div[@id="image-block"]/span[@id="view_full_size"]/img[@id="bigpic"]/@src').text
    i=0
    while i < prices.length
      products[counte] = [title+" - "+attnames[i], prices[i], img]
      counte +=1
      i+=1
    end
  end
end
puts '=======>>>>>'
puts products.length

x = 1
CSV.open('text.csv', 'w') do |writer|
  products.each do |a|
    b = x.to_s+") "+a[0]+"         "+a[1]+"         "+a[2]
    writer << [b]
    x+=1
  end
end

