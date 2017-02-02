require 'open-uri'
require 'nokogiri'
require 'csv'

def for_each_page
  category_url = ARGV[0]
  loop do
    puts category_url
    category_page = get_page(category_url)
    category_url = get_next_url(category_page)
    yield category_page
    break unless category_url
  end
end

def get_page(url)
  Nokogiri::HTML(open(url))
end

def get_next_url(category_page)
  url_sufix = category_page.xpath('//li[@id="pagination_next_bottom"]/a/@href').text
  return if url_sufix.empty?
  next_category_url = site_url + url_sufix
  next_category_url
end

def site_url
  ARGV[0][/[\w\W]+\.\w+/]
end

def for_each_products_urls(page)
  divs = products_urls(page)
  divs.each do |div|
    yield div
  end
end

def products_urls(page)
  page.xpath('//div[@class="productlist"]/div/div/div/div/div/a[@class="product_img_link"]/@href').map{ |element| element.text }
end

def parses_product_page(product_page)
  product=[]
  product_page.xpath('//div/div/section/div/div[@class="row"]').each do |product_div|
    title = product_div.xpath('//div[@id="right"]/div/div/div[@class="product-name"]/h1/text()').text.strip
    img = product_div.xpath('//div[@id="left"]/div/div/span/img[@id="bigpic"]/@src').text
    product_div.xpath('//div[@id="attributes"]/fieldset/div/ul[@class="attribute_labels_lists"]/li').each do |li|
      product << get_price_attname(li).merge({title: title, image: img})
    end
  end
  product
end

def get_price_attname(li)
attname = li.xpath('.//span[@class="attribute_name"]/text()').text[/[\w\s]+/]
price = li.xpath('.//span[@class="attribute_price"]/text()').text().strip[/[\w]+\.\w+/]
{attname: attname, price: price}
end

products = []
for_each_page do |page|
  for_each_products_urls(page) do |product_url|
    product_page = get_page(product_url)
    products += parses_product_page(product_page)
  end
end

output_file_name = ARGV[1]
x = 1
CSV.open(output_file_name, 'w') do |writer|
  writer << ["Name", "Price", "Image"]
  products.each do |product|
    writer << [product[:title] + ' - ' + product[:attname], product[:price], product[:image]]
    x+=1
  end
end

#ruby receivingElements2.rb http://www.petsonic.com/es/perros/snacks-y-huesos-perro test2.csv

