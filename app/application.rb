class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = []

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    elsif req.path.match(/cart/)
      @@cart.empty? ? 
        resp.write("Your cart is empty") : 
        @@cart.each { |item| resp.write "#{item}\n" }
    elsif req.path.match(/add/)

      in_cart = req.params["item"]
        if @@items.include?(in_cart)
          @@cart << in_cart
          resp.write "added #{in_cart}"
        else
          resp.write "We don't have that item"
        end

    else
      resp.write "Path Not Found"
    end

    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end
end
