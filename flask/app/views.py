from flask import render_template, flash, redirect, session, url_for, request
from datetime import datetime
from app import app


@app.errorhandler(404)
def not_found_error(error):
    return render_template('404.html'), 404


@app.errorhandler(500)
def internal_error(error):
    db.session.rollback()
    return render_template('500.html'), 500


@app.route('/', methods=['GET', 'POST'])
@app.route('/index', methods=['GET', 'POST'])
def index():
    return render_template('index.html',
                           title='Home' )

@app.route('/sb1/', methods=['GET'])
def sb1():
    return render_template('sb1.html')
