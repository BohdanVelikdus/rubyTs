require 'json'
require 'bcrypt'

class SecurityLogin
    private
    attr :file
    public 
    attr_accessor :data

    # open file 
    def initialize
        @file  = File.open("users_data.json", 'r+')
        extract_data()
    end

    # here extracting data from file
    public
    def extract_data
        content = @file.read()
        @data = JSON.parse(content)
    end


    # bool if exist
    public 
    def check_existing(username)
        @data.each do |hash|
            if hash["username"] == username
                return true
            else 
                return false
            end
        end
        return false
    end


    # registering after checking
    public
    def registering_user(username, password)
        hashed_password = BCrypt::Password.create(password)
        pair = { "username": username, "password": hashed_password}
        @data.push(pair)
        write_to_file(@data)
    end


    public
    def write_to_file(array)
        data = JSON.pretty_generate(array)
        @file.write(data)
    end

    #login for name and password
    public 
    def login_check(username, password)
        contains_name = @data.any? { |hash| hash["username"] == username }
        if contains_name
            hashed_specified = @data.find{ |hash| hash["username"] == username} 
            true_password = hashed_specified["password"]
            hashed_password_for_check = BCrypt::Password.new(true_password)
            if hashed_password_for_check == password
                return "Logined successfully"
            else 
                return "Error while Login"
            end
        else
            return "Error while login"
        end
    end

    # close file
    def at_exit
        @file.close()
    end

end


loop do
    secLog = SecurityLogin.new
    puts "Choose option:"
    puts "\tLogin - 1"
    puts "\tRegister - 2"
    puts "\tExit - 3"
    check = gets.chomp.strip

    if check == "1"
        puts "Login checked"
        puts "Enter the user"
        user = gets.chomp.strip
        puts "Enter the password"
        pass = gets.chomp.strip
        puts secLog.login_check(user, pass)
    elsif check == "2"
        puts "Register checked"
        puts "Entered username"
        username = gets.chomp.strip
        puts "Entered password"
        password = gets.chomp.strip
        
        if secLog.check_existing(username)
            puts "User exist with such username, try Login"
        else 
            secLog.registering_user(username, password)
            puts "Ok, now you`re registered"
        end
    elsif check == "3" 
        puts "Exit checked, break"
        break
    else
        puts "Error check, reenter info"
    end

end