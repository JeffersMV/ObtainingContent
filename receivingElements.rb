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
url = 'http://www.petsonic.com/es/perros/snacks-y-huesos-perro'
html = open(url)
require 'nokogiri'
page = Nokogiri::HTML(html)
page.xpath('//div[@class="productlist"]/div/div/div/div/div/a[@class="product_img_link"]/@href').each do |link|
  puts link
  multiProductPage=Nokogiri::HTML(open(link))
  #products = []
  multiProductPage.xpath('//div[@class="container"]/div[@class="row"]/section[@id="center_column"]
/div[@class="primary_block"]/div[@class="row"]').each do |productlink|
    #title_el = productlink.at_css('h1 a')
    #title_el.children.each { |c| c.remove if c.name == 'span' }
    #name = title_el.text.strip

    title = productlink.xpath('//div[@id="right"]/div[@class="pb-center-column"]
/div[@class=" col-xs-10"]/div[@class="product-name"]/h1')

    #title = 'Caja de Navidad para Perro' что бы выводило

    price =productlink.xpath('//div[@id="right"]/div[@class="pb-center-column"]
/div[@class="box-center clearfix"]/form[@id="buy_block"]/div[@class="box-product-center"]
/div[@class="product_attributes"]/div[@id="attributes"]/fieldset[@class="attribute_fieldset"]
/div[@class="attribute_list"]/ul[@class="attribute_labels_lists"]/li/span[@class="attribute_price"]').text.strip

    #price =    тут что бы выводило несколько цен в массив

    img = productlink.xpath('//div[@id="left"]/div[@id="sidebar"]/div[@id="image-block"]/span[@id="view_full_size"]/img[@id="bigpic"]/@src')
    puts img
    puts price
    puts title
    puts
  end
  puts
end

