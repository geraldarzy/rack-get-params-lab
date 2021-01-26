class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart =[]

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
    elsif req.path.match (/cart/)
      @@cart.each do |item|
        resp.write "#{item}\n"
      end
      if @@cart.count <= 0 
        resp.write "Your cart is empty"
      end
    elsif req.path.match(/add/)
      search_term = req.params["item"]
      resp.write check_items(search_term)
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
  
  def check_items(search_term)
    if handle_search(search_term).include?("is one of our items")
      @@cart << search_term
      return "added #{search_term}"
    else
      return "We don't have that item"
    end
  end
end
