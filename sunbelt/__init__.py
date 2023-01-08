# -*- coding: utf-8 -*-

import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config["SQLALCHEMY_DATABASE_URI"] = os.environ['MAIN_MEDIA_DATABASE']
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
db = SQLAlchemy(app)


@app.route('/')
def hello():
    return 'Hello!'


from ariadne import load_schema_from_path, make_executable_schema, \
    graphql_sync, snake_case_fallback_resolvers, ObjectType
from ariadne.constants import PLAYGROUND_HTML
from flask import request, jsonify
from sunbelt.api.queries import resolve_posts, resolve_post
from sunbelt import app

query = ObjectType("Query")

query.set_field("post", resolve_post)
query.set_field("posts", resolve_posts)

type_defs = load_schema_from_path("api/schema.graphql")
schema = make_executable_schema(
    type_defs, query, snake_case_fallback_resolvers
)

@app.route("/graphql", methods=["GET"])
def graphql_playground():
    return PLAYGROUND_HTML, 200


@app.route("/graphql", methods=["POST"])
def graphql_server():
    data = request.get_json()

    success, result = graphql_sync(
        schema,
        data,
        context_value=request,
        #debug=app.debug
    )

    status_code = 200 if success else 400
    return jsonify(result), status_code

