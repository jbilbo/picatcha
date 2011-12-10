require "uri"
module Picatcha
  module Verify
    # Your private API can be specified in the +options+ hash or preferably
    # using the Configuration.
    def verify_picatcha(options = {})
      if !options.is_a? Hash
        options = {:model => options}
      end

      env = options[:env] || ENV['RAILS_ENV']
      return true if Picatcha.configuration.skip_verify_env.include? env
      model = options[:model]
      attribute = options[:attribute] || :base
      private_key = options[:private_key] || Picatcha.configuration.private_key
      raise PicatchaError, "No private key specified." unless private_key

      begin
        picatcha = nil
        if(Picatcha.configuration.proxy)
          proxy_server = URI.parse(Picatcha.configuration.proxy)
          http = Net::HTTP::Proxy(proxy_server.host, proxy_server.port, proxy_server.user, proxy_server.password)
        else
          http = Net::HTTP
        end
        
        
        # checks if the picatcha is empty, if so then returns false
        if params[:picatcha]["r"]==nil
          flash[:error] = "Please fill out Picatcha before proceeding"
          return false
        end


        data = {
          "k" => private_key,
          "ip" => request.remote_ip,
          "ua"=> "Picatcha Ruby Gem",
          "s" => params[:picatcha][:stages],  #the number of stages
          "t" => params[:picatcha][:token],   #the challenge token
          "r" => params[:picatcha][:r]        #the array of images
        }
        
        
        payload = data.to_json
        

        Timeout::timeout(options[:timeout] || 3) do
          uri = URI.parse(Picatcha.configuration.verify_url)
          http= Net::HTTP.new(uri.host, uri.port)
          
          request = Net::HTTP::Post.new(uri.request_uri)
          request.body = payload
          
          response = http.request(request)
        end
        
        parsed_json = JSON(@body_response)
        
        # so far just a simple if.. else to check if the picatcha was 
        # solved correctly. will revisit later and make it more
        # verbose
        if parsed_json["s"]==true
          return true
        else
          return false
        end
        
      end
    end # verify_picatcha
  end # Verify
end # Picatcha
