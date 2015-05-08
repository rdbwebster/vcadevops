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

@app.route('/env/', methods=['GET'])
def env():
    return render_template('env.html')


@app.route('/sp1/', methods=['GET'])
def sp1():
    return render_template('sp1.html')

@app.route('/sb2/', methods=['GET'])
def sb2():
    return render_template('sb2.html')

@app.route('/ck1/', methods=['GET'])
def ck1():
    return render_template('ck1.html')

@app.route('/cl1/', methods=['GET'])
def cl1():
    return render_template('cl1.html')

@app.route('/dp1/', methods=['GET'])
def dp1():
    return render_template('dp1.html')
