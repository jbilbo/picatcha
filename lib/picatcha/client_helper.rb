module Picatcha
  module ClientHelper
    # Your public API can be specified in the +options+ hash or preferably
    # using the Configuration.
    def picatcha_tags(options = {})
      # Default options
      key   = options[:public_key] ||= Picatcha.configuration.public_key
      raise PicatchaError, "No public key specified." unless key
      error = options[:error] ||= (defined? flash ? flash[:picatcha_error] : "")
      uri   = Picatcha.configuration.api_server_url(options[:ssl])
      html  = ""
      elm_id = "picatcha"
      
      if options[:display]
        html << %{<script type="text/javascript">\n}
        html << %{  var RecaptchaOptions = #{options[:display].to_json};\n}
        html << %{</script>\n}
      end
      #if options[:ajax]
        html << <<-EOS
            <script type="text/javascript" src="#{uri}/static/client/jquery.min.js"></script>
            <script type="text/javascript" src="#{uri}/static/client/picatcha.js"></script>
            <link href="#{uri}/static/client/picatcha.css" rel="stylesheet" type="text/css">
            <script>Picatcha.PUBLIC_KEY="#{key}";window.onload=function(){Picatcha.create("#{elm_id}", {});};</script>
            <div id="#{elm_id}"></div>
        EOS
        #html << <<-EOS
#          <div id="dynamic_recaptcha"></div>
#          <script type="text/javascript">
#            var rc_script_tag = document.createElement('script'),
#                rc_init_func = function(){Recaptcha.create("#{key}", document.getElementById("dynamic_recaptcha")#{',RecaptchaOptions' if options[:display]});}
#            rc_script_tag.src = "#{uri}/js/recaptcha_ajax.js";
#            rc_script_tag.type = 'text/javascript';
#            rc_script_tag.onload = function(){rc_init_func.call();};
#            rc_script_tag.onreadystatechange = function(){
#              if (rc_script_tag.readyState == 'loaded' || rc_script_tag.readyState == 'complete') {rc_init_func.call();}
#            };
#            (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(rc_script_tag);
#          </script>
#        EOS
      # else
      #   html << %{<script type="text/javascript" src="#{uri}/challenge?k=#{key}}
      #   html << %{#{error ? "&amp;error=#{CGI::escape(error)}" : ""}"></script>\n}
      #   unless options[:noscript] == false
      #     html << %{<noscript>\n  }
      #     html << %{<iframe src="#{uri}/noscript?k=#{key}" }
      #     html << %{height="#{options[:iframe_height] ||= 300}" }
      #     html << %{width="#{options[:iframe_width]   ||= 500}" }
      #     html << %{style="border:none;"></iframe><br/>\n  }
      #     html << %{<textarea name="recaptcha_challenge_field" }
      #     html << %{rows="#{options[:textarea_rows] ||= 3}" }
      #     html << %{cols="#{options[:textarea_cols] ||= 40}"></textarea>\n  }
      #     html << %{<input type="hidden" name="recaptcha_response_field" value="manual_challenge"/>}
      #     html << %{</noscript>\n}
      #   end
      #end
      return (html.respond_to?(:html_safe) && html.html_safe) || html
    end # picatcha_tags
  end # ClientHelper
end # Picatcha
