# -*- coding: utf-8 -*-

import os
from dotenv import load_dotenv
load_dotenv()

from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate

from datetime import datetime, timedelta


from flask_jwt_extended import JWTManager, create_access_token, create_refresh_token, get_jwt_identity, get_jwt


from ariadne import QueryType

app = Flask(__name__)

# FLASK_ENV variable is depreciated and FLASK_DEBUG is used instead.
# Debug = True means development mode.

if app.debug:
    app.config["SQLALCHEMY_DATABASE_URI"] = os.environ['LOCAL_SUNBELT_DB_URL'] #'sqlite:///app.db'
else:
    app.config["SQLALCHEMY_DATABASE_URI"] = os.environ['LOCAL_SUNBELT_DB_URL']
    #app.config["SQLALCHEMY_DATABASE_URI"] = os.environ['HEROKU_SUNBELT_DB_URL']


app.config["JWT_SECRET_KEY"] = os.environ['JWT_SECRET_KEY']
jwt = JWTManager(app)

db = SQLAlchemy(app)
migrate = Migrate(app, db)
#celery_app = celery_init_app(app)

query = QueryType()

@app.route('/')
def hello():
    return 'Hello!'

@app.route('/auth', methods=['POST'])
def auth():
    username = request.json.get('username', None)
    password = request.json.get('password', None)
    if username != 'admin' or password != os.environ['ADMIN_PASSWORD']:
        return jsonify({"msg": "Bad username or password"}), 401
    access_token = create_access_token(identity=username)
    refresh_token = create_refresh_token(identity=username)
    return jsonify(access_token=access_token, refresh_token=refresh_token), 200

# Using an `after_request` callback, we refresh any token that is within 30
# minutes of expiring. Change the timedeltas to match the needs of your application.
@app.after_request
def refresh_expiring_jwts(response):
    try:
        exp_timestamp = get_jwt()["exp"]
        now = datetime.now(timezone.utc)
        target_timestamp = datetime.timestamp(now + timedelta(minutes=30))
        if target_timestamp > exp_timestamp:
            access_token = create_access_token(identity=get_jwt_identity())
            set_access_cookies(response, access_token)
        return response
    except (RuntimeError, KeyError):
        # Case where there is not a valid JWT. Just return the original response
        return response

@app.errorhandler(500)
def server_error(e):
    # Log the error and stacktrace.
    logging.exception('An error occurred during a request.')
    return 'An internal error occurred.', 500


    
