#!/home/xpizta/.rvm/rubies/ruby-2.3.1/bin/ruby

require 'rubygems'
require 'nokogiri'
require 'mechanize'
require 'highline'

time = Time.new
now_time = "#{time.year}#{time.strftime("%m")}#{time.day}"
puts now_time

password = HighLine.new
print "Input your name: "
name = gets.chomp
pwd = password.ask("Password:  ") { |q| q.echo = "*" }
puts ""

agent = Mechanize.new
login_page = agent.get('http://ntcbadm1.ntub.edu.tw/')
login_form = login_page.form

name_field = login_form.field_with(type: "text")
pwd_field = login_form.field_with(type: "password")
name_field.value = name
pwd_field.value = pwd
puts "學號：#{name}\n "

home_page = login_form.click_button

main_page = agent.get('http://ntcbadm1.ntub.edu.tw/StdAff/STDWeb/ABS_SearchSACP.aspx')

doc = main_page.parser
all = doc.css("#ctl00_ContentPlaceHolder1_GRD").text

system 'mkdir', '-p', ENV['HOME'] + "/缺曠" #unless Dir.exists?("~/缺曠")
#FileUtils::mkdir_p '~/缺曠'


type = ["假別","日期","星期","節次"]
a = 0
t_name = "#{now_time}.txt"
File.open(ENV['HOME'] + "/缺曠/#{t_name}", "w+") do |file|
  doc.css("#ctl00_ContentPlaceHolder1_GRD td").each do |t|
    line = t.text.delete "\n\r "
    puts need = "#{type[a]}：#{line}"
    file.puts "#{need}"
    a += 1
    if a == 4
      a = 0
      puts ""
      file.puts ""
    end
  end
  puts total = doc.css("#ctl00_ContentPlaceHolder1_Lab_count").text.delete(" ")
  file.puts total
end


