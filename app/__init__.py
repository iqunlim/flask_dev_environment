from flask import Flask
from flask import abort, request

import re
import os

def create_app():

    app = Flask(__name__)

    app.config.from_mapping(
        SECRET_KEY="dev-randomnumbers234234",
    )
    
    #dev security keeping nasty dudes from connecting externally. 
    #all addresses on the dev should be forwarded to your local machine
    allowed_ips = [re.compile(r"192\.168\.[0-9]*\.[0-9]*"), 
                re.compile(r"172\.[0-9]*\.[0-9]*\.[0-9]*"), re.compile("127\.0\.0\.1")]
    
    @app.before_request
    def limit_remote_addr():
        if app.debug == True and not any(re.match(regex, request.remote_addr) for regex in allowed_ips):
            return abort(403)
    
    @app.route('/')
    def index():
        return "<p>Hello from Dockerized flask app!</p>"
    
    return app

#added here for posterity more than anything.
if __name__ == "__main__":
    create_app().run(debug=True)