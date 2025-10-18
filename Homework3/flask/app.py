from flask import Flask, jsonify, request, render_template, redirect
from models import db, User
import os

app = Flask(__name__)

app.config["SQLALCHEMY_DATABASE_URI"] = os.environ.get("DATABASE_URL")
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db.init_app(app)


with app.app_context():
    db.create_all()

@app.route('/')
def index():
    users = User.query.all()
    return render_template('index.html', users=users)

@app.route('/add', methods=['POST'])
def add_user_ui():
    name = request.form.get("name")
    if name:
        user = User(name=name)
        db.session.add(user)
        db.session.commit()
    return redirect('/')

# API endpoints (still available)
@app.route('/users', methods=['GET'])
def list_users():
    users = User.query.all()
    return jsonify([{"id": u.id, "name": u.name} for u in users])

@app.route('/users', methods=['POST'])
def create_user():
    data = request.get_json()
    if not data or "name" not in data:
        return jsonify({"error": "Missing name"}), 400
    user = User(name=data["name"])
    db.session.add(user)
    db.session.commit()
    return jsonify({"status": "User added"}), 201

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
